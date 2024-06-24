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

M.find = function(input, callback)
  for _, value in ipairs(input) do
    if callback(value) then
      return value
    end
  end
end

local map = function(input, callback)
  local output = {}

  if type(input) == "table" then
    for key, value in pairs(input) do
      table.insert(output, callback(value, key))
    end
  else
    for value in input do
      table.insert(output, callback(value))
    end
  end

  return output
end

M.map = map

local add_lines_to_qf = function(lines, qf_item)
  vim.fn.setqflist(
    map(lines:gmatch("[^%c]+"), function(line)
      return vim.tbl_extend("error", qf_item, {
        text = line,
      })
    end),
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

  local start_time = vim.loop.hrtime()

  return vim.system(command, opts, function(system_obj)
    local end_time = vim.loop.hrtime()

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
    M.async_run(vim.list_extend({ "git" }, sub_command), { cwd = LazyVim.root() })
  end
end

M.async_run_sh = function(command, opts, callback)
  return M.async_run({ "sh", "-c", command }, opts, callback)
end

M.git_stdout = function(sub_command)
  return M.stdout_without_newline(vim.list_extend({ "git" }, sub_command))
end

M.highlights = {}

M.normname = function(name)
  return (name:gsub("^.*/", ""):gsub("[%.%-]?nvim%-?", ""))
end

M.open_url = function(url)
  local edge_path = "/Microsoft/Edge/Application/msedge.exe"

  vim.system(
    vim.list_extend(
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
        ),
      { url }
    )
  )
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

M.rainbow_delimiters_hl = map(M.rainbow_colors, function(color)
  return "RainbowDelimiter" .. color
end)

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

  local start_time = vim.loop.hrtime()

  local system_obj = vim.system(command, opts):wait()

  local end_time = vim.loop.hrtime()

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
