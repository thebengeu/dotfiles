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

local delete_trailing_blank_lines = function(bufnr)
  while vim.api.nvim_buf_get_lines(bufnr, -2, -1, true)[1] == "" do
    vim.api.nvim_buf_set_lines(bufnr, -2, -1, true, {})
  end
end

local win_exec_normal = function(winid, key)
  vim.fn.win_execute(winid, 'execute "normal \\' .. key .. '"')
end

local setup_input = function(amend, reset_on_close)
  local input = Input(popup_options("Commit Summary"), {
    default_value = amend and vim
      .system({ "git", "show", "--format=%s", "--no-patch" })
      :wait().stdout
      :gsub("\n$", "") or nil,
    on_close = reset_on_close and function()
      vim.system({ "git", "reset" })
    end or nil,
    on_submit = function(commit_summary)
      if commit_summary ~= "" then
        util.async_run_sh(
          "git commit"
            .. (amend and " --amend" or "")
            .. ' -m "'
            .. commit_summary:gsub('["`$]', "\\%1")
            .. '" && git push --force-if-includes --force-with-lease',
          function()
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
        width = 80,
      },
    },
    Layout.Box({
      Layout.Box(input, { size = 4 }),
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

  vim.api.nvim_buf_call(term_bufnr, function()
    vim.fn.termopen(
      "git diff "
        .. (no_changes and "@^" or "--cached")
        .. " | delta --pager never",
      {
        on_exit = function()
          local interval = 10
          local timer = vim.uv.new_timer()

          timer:start(
            interval,
            interval,
            vim.schedule_wrap(function()
              if vim.api.nvim_buf_is_valid(term_bufnr) then
                set_modifiable(true)
                delete_trailing_blank_lines(term_bufnr)
                set_modifiable(false)

                if
                  vim.api.nvim_buf_get_lines(term_bufnr, -2, -1, true)[1]
                  ~= "[Process exited 0]"
                then
                  return
                end

                set_modifiable(true)
                vim.api.nvim_buf_set_lines(term_bufnr, -2, -1, true, {})
                delete_trailing_blank_lines(term_bufnr)
                set_modifiable(false)
              end

              timer:stop()
              timer:close()
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

local git_commit = function(amend)
  vim.cmd.update()

  local has_staged = system_sh_code("git diff --cached --quiet") ~= 0
  local no_changes = not has_staged
    and system_sh_code("git add --all && git diff --cached --quiet") == 0

  if no_changes and not amend then
    vim.notify("No changes found", vim.log.levels.WARN)
    return
  end

  local input = setup_input(amend, not has_staged and not no_changes)
  local term = Popup(popup_options("Diff"))
  local layout = setup_layout(input, term)

  layout:mount()
  termopen_git_diff(term, no_changes)
end

vim.keymap.set("n", "<leader>k", git_commit, { desc = "Commit" })
vim.keymap.set("n", "<leader>ga", function()
  git_commit(true)
end, { desc = "Amend" })
