local LazyVim = require("lazyvim.util")

local M = {}

M.extra_specs = {}

M.filter = function(input, callback)
  local output = {}

  for _, value in ipairs(input) do
    if callback(value) then
      table.insert(output, value)
    end
  end

  return output
end

local add_lines_to_qf = function(lines, qf_item)
  vim.fn.setqflist(
    vim
      .iter(lines:gmatch("[^%c]+"))
      :map(function(line)
        return vim.tbl_extend("error", qf_item, {
          text = line,
        })
      end)
      :totable(),
    "a"
  )
end

M.async_run = function(command, opts, callback)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local qf_item = {
    col = cursor[2],
    filename = vim.api.nvim_buf_get_name(0),
    lnum = cursor[1],
    type = "I",
  }

  add_lines_to_qf(table.concat(command, " "):gsub("^sh %-c ", ""), qf_item)

  local start_time = vim.uv.hrtime()

  return vim.system(command, opts, function(system_obj)
    local end_time = vim.uv.hrtime()

    vim.schedule(function()
      if system_obj.code ~= 0 then
        qf_item.type = "E"

        add_lines_to_qf(system_obj.stdout, qf_item)
        add_lines_to_qf(system_obj.stderr, qf_item)

        vim.cmd.copen()
      elseif #system_obj.stdout > 0 or #system_obj.stderr > 0 then
        vim.notify(
          system_obj.stdout
            .. system_obj.stderr
            .. "Executed in "
            .. math.floor((end_time - start_time) / 1e6)
            .. "ms"
        )
      end

      vim.cmd.cbottom()

      if callback then
        callback(system_obj)
      end
    end)
  end)
end

M.async_run_git = function(sub_command)
  return function()
    M.async_run({ "git", unpack(sub_command) }, { cwd = LazyVim.root() })
  end
end

M.async_run_sh = function(command, opts, callback)
  return M.async_run({ "sh", "-c", command }, opts, callback)
end

M.git_stdout = function(sub_command)
  return M.stdout_without_newline({ "git", unpack(sub_command) })
end

M.colorscheme_style = nil

M.get_directory = function(picker_name_or_callback, cwd)
  return function()
    cwd = cwd or vim.uv.cwd()
    local visual = Snacks.picker.util.visual()

    require("telescope.pickers")
      .new({}, {
        attach_mappings = function(prompt_bufnr)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          actions.select_default:replace(function()
            local selected_entry_value = action_state.get_selected_entry().value
            local multi_selection = action_state
              .get_current_picker(prompt_bufnr)
              :get_multi_selection()
            local search_dirs = {}

            actions.close(prompt_bufnr)

            if vim.tbl_isempty(multi_selection) then
              local selected_path = cwd .. "/" .. selected_entry_value

              if type(picker_name_or_callback) == "function" then
                picker_name_or_callback(selected_path)
                return
              elseif picker_name_or_callback == "smart" then
                M.smart({ cwd = selected_path })()
                return
              end

              table.insert(search_dirs, selected_entry_value)
            else
              for _, selection in ipairs(multi_selection) do
                table.insert(search_dirs, selection.value)
              end
            end

            require("telescope").extensions.egrepify.egrepify({
              cwd = cwd,
              default_text = visual and visual.text,
              search_dirs = search_dirs,
            })
          end)
          return true
        end,
        finder = require("telescope.finders").new_oneshot_job({
          "fd",
          "--follow",
          "--max-depth",
          "1",
          "--type",
          "directory",
        }, {
          cwd = cwd,
          entry_maker = require("telescope.make_entry").gen_from_file({
            cwd = cwd,
          }),
        }),
        layout_config = {
          horizontal = {
            preview_width = 122,
          },
        },
        previewer = require("telescope.previewers").new_termopen_previewer({
          get_command = function(entry)
            local directory = cwd .. "/" .. entry.value
            local readme = directory .. "/README.md"

            return vim.fn.filereadable(readme) == 1 and { "glow", readme }
              or {
                "eza",
                "--all",
                "--git",
                "--group-directories-first",
                "--icons",
                "--long",
                "--no-user",
                directory,
              }
          end,
        }),
        sorter = require("telescope.config").values.file_sorter(),
      })
      :find()
  end
end

M.highlights = {}

M.set_highlights = function()
  local get_highlights = M.highlights[vim.g.colors_name]

  if get_highlights then
    for name, highlight in pairs(get_highlights(M.colorscheme_style)) do
      vim.api.nvim_set_hl(0, name, highlight)
    end
  end
end

M.normname = function(name)
  return (name:gsub("^.*/", ""):gsub("[%.%-]?nvim%-?", ""))
end

M.open_url = function(url)
  local edge_path = "/Microsoft/Edge/Application/msedge.exe"

  vim.system({
    unpack(
      jit.os == "OSX" and { "open" }
        or (
          vim.env.TITLE_PREFIX == "wsl:"
            and {
              "/mnt/c/Program Files (x86)" .. edge_path,
            }
          or (
            vim.env.SSH_CONNECTION and { "lmn", "open" }
            or {
              vim.env["ProgramFiles(x86)"] .. edge_path,
            }
          )
        )
    ),
    url,
  })
end

M.rainbow_colors = {
  "Red",
  "Yellow",
  "Blue",
  "Orange",
  "Green",
  "Violet",
  "Cyan",
}

M.rainbow_delimiters_hl = vim
  .iter(M.rainbow_colors)
  :map(function(color)
    return "RainbowDelimiter" .. color
  end)
  :totable()

M.smart = function(opts)
  return function()
    Snacks.picker.smart(opts)
  end
end

M.stdout_without_newline = function(command)
  return vim
    .system(command, { cwd = LazyVim.root() })
    :wait().stdout
    :gsub("\n$", "")
end

M.sync_run = function(command, opts)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local qf_item = {
    col = cursor[2],
    filename = vim.api.nvim_buf_get_name(0),
    lnum = cursor[1],
    type = "I",
  }

  add_lines_to_qf(table.concat(command, " "):gsub("^sh %-c ", ""), qf_item)

  local start_time = vim.uv.hrtime()

  local system_obj = vim.system(command, opts):wait()

  local end_time = vim.uv.hrtime()

  if system_obj.code == 0 then
    vim.notify(
      system_obj.stdout
        .. system_obj.stderr
        .. "Executed in "
        .. math.floor((end_time - start_time) / 1e6)
        .. "ms"
    )
  else
    qf_item.type = "E"

    add_lines_to_qf(system_obj.stdout, qf_item)
    add_lines_to_qf(system_obj.stderr, qf_item)

    vim.cmd.copen()
  end

  vim.cmd.cbottom()

  return system_obj
end

M.visual_lines = function()
  local lines = { vim.fn.line("v"), vim.fn.line(".") }

  table.sort(lines)

  return lines
end

return M
