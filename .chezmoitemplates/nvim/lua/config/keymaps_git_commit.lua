local Input = require("nui.input")
local Layout = require("nui.layout")
local Popup = require("nui.popup")
local util = require("util")

local popup_options = function(title)
  return {
    border = {
      style = "rounded",
      text = {
        top = " " .. title .. " ",
      },
    },
    win_options = {
      winhighlight = "FloatBorder:Normal,Normal:Normal",
    },
  }
end

local win_exec_normal = function(winid, key)
  vim.fn.win_execute(winid, 'execute "normal \\' .. key .. '"')
end

local saved_commit_summary

local setup_input = function(reset_on_close, git_subcommand, default_message)
  local input = Input(popup_options("Commit Summary"), {
    default_value = default_message or saved_commit_summary,
    on_change = function(commit_summary)
      saved_commit_summary = commit_summary
    end,
    on_close = reset_on_close and function()
      vim.system({ "git", "reset" })
    end or nil,
    on_submit = function(commit_summary)
      if commit_summary ~= "" then
        util.async_run_sh(
          "git "
            .. git_subcommand
            .. ' -m "'
            .. commit_summary:gsub('["`$]', "\\%1")
            .. '" && git push --force-if-includes --force-with-lease',
          function()
            saved_commit_summary = nil
            require("gitsigns").refresh()
          end
        )
      end
    end,
  })

  local unmount = input.unmount
  ---@diagnostic disable-next-line: duplicate-set-field
  input.unmount = function(self)
    ---@diagnostic disable-next-line: invisible
    if self._.loading then
      return
    end

    unmount(self)
  end

  return input
end

local setup_layout = function(input, term)
  local layout = Layout(
    {
      position = "50%",
      relative = "editor",
      size = {
        height = "90%",
        width = vim.o.columns > 90 and 160 or 80,
      },
    },
    Layout.Box({
      Layout.Box(input, { size = 3 }),
      Layout.Box(term, { grow = 1 }),
    }, { dir = "col" })
  )

  term:map("n", "<Esc>", function()
    layout:unmount()
  end)

  term:map("n", "<C-k>", function()
    vim.api.nvim_set_current_win(input.winid)
  end)

  for _, key in ipairs({ "b", "d", "e", "f", "u", "y" }) do
    local ctrl_key = "<C-" .. key .. ">"
    input:map("i", ctrl_key, function()
      win_exec_normal(term.winid, ctrl_key)
    end)
  end

  for _, mode in ipairs({ "i", "n" }) do
    input:map(mode, "<C-j>", function()
      vim.api.nvim_set_current_win(term.winid)
    end)
  end

  input:map("n", "<Esc>", function()
    layout:unmount()
  end)

  return layout
end

local termopen_git_diff = function(term, no_changes)
  local term_bufnr = term.bufnr

  local set_modifiable = function(value)
    vim.api.nvim_set_option_value("modifiable", value, { buf = term_bufnr })
  end

  local delete_trailing_blank_lines = function()
    while vim.api.nvim_buf_get_lines(term_bufnr, -2, -1, true)[1] == "" do
      vim.api.nvim_buf_set_lines(term_bufnr, -2, -1, true, {})
    end
  end

  vim.api.nvim_buf_call(term_bufnr, function()
    vim.fn.termopen(
      "git diff "
        .. (no_changes and "@^" or "--cached")
        .. " | delta --pager never"
        .. (vim.o.columns > 90 and " --side-by-side" or ""),
      {
        on_exit = function()
          local interval = 10
          local timer = vim.uv.new_timer()
          local timer_closing

          timer:start(
            interval,
            interval,
            vim.schedule_wrap(function()
              if timer_closing then
                return
              end

              if vim.api.nvim_buf_is_valid(term_bufnr) then
                set_modifiable(true)
                delete_trailing_blank_lines()
                set_modifiable(false)

                if
                  vim.api.nvim_buf_get_lines(term_bufnr, -2, -1, true)[1]
                  ~= "[Process exited 0]"
                then
                  return
                end

                set_modifiable(true)
                vim.api.nvim_buf_set_lines(term_bufnr, -2, -1, true, {})
                delete_trailing_blank_lines()
                set_modifiable(false)
              end

              timer:stop()
              timer:close()
              timer_closing = true
            end)
          )
        end,
        on_stdout = function()
          local first_visible_line_num = vim.fn.line("w0", term.winid)

          if
            first_visible_line_num
            and vim.api.nvim_buf_get_lines(
                term_bufnr,
                first_visible_line_num - 1,
                first_visible_line_num,
                true
              )[1]
              == ""
          then
            win_exec_normal(term.winid, "<C-e>")
          end
        end,
      }
    )
  end)
end

local system_sh_code = function(cmd)
  return vim.system({ "sh", "-c", cmd }):wait().code
end

local git_commit = function(git_command, default_message)
  local has_staged = system_sh_code("git diff --cached --quiet") ~= 0
  local no_changes = not has_staged
    and system_sh_code("git add --all && git diff --cached --quiet") == 0

  if no_changes and not default_message then
    vim.notify("No changes found", vim.log.levels.WARN)
    return
  end

  local input =
    setup_input(not has_staged and not no_changes, git_command, default_message)
  local term = Popup(popup_options("Diff"))
  local layout = setup_layout(input, term)

  layout:mount()
  termopen_git_diff(term, no_changes)
end

vim.keymap.set("n", "<leader>k", function()
  vim.cmd.update()
  git_commit("commit")
end, { desc = "Commit" })

vim.keymap.set("n", "<leader>gA", function()
  vim.cmd.update()

  require("telescope.builtin").git_commits({
    attach_mappings = function()
      local actions = require("telescope.actions")

      actions.select_default:replace(function(prompt_bufnr)
        local selected_entry =
          require("telescope.actions.state").get_selected_entry()
        actions.close(prompt_bufnr)

        vim.schedule(function()
          git_commit("revise " .. selected_entry.value, selected_entry.msg)
        end)
      end)

      return true
    end,
  })
end, { desc = "Amend Selected Commit" })

vim.keymap.set("n", "<leader>ga", function()
  vim.cmd.update()
  git_commit(
    "commit --amend",
    vim
      .system({ "git", "show", "--format=%s", "--no-patch" })
      :wait().stdout
      :gsub("\n$", "")
  )
end, { desc = "Amend" })
