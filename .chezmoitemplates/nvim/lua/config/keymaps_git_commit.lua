local LazyVim = require("lazyvim.util")
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

local setup_input = function(
  is_thebengeu_repo,
  root,
  reset_on_close,
  git_subcommand,
  default_message
)
  local Input = require("nui.input")

  local input = Input(popup_options("Commit Summary"), {
    default_value = default_message or saved_commit_summary or "feat: ",
    on_change = function(commit_summary)
      saved_commit_summary = commit_summary
    end,
    on_close = reset_on_close and function()
      vim.system({ "git", "reset" }, { cwd = root })
    end or nil,
    on_submit = function(commit_summary)
      if commit_summary ~= "" then
        util.async_run_sh(
          "git "
            .. git_subcommand
            .. ' -m "'
            .. commit_summary:gsub('["`$]', "\\%1")
            .. '"'
            .. (
              is_thebengeu_repo
                and " && git push --force-if-includes --force-with-lease"
              or ""
            ),
          { cwd = root },
          function(system_obj)
            if system_obj.code == 0 then
              saved_commit_summary = nil
              require("gitsigns").refresh()
            end
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
  local Layout = require("nui.layout")

  local layout = Layout(
    {
      position = "50%",
      relative = "editor",
      size = {
        height = "90%",
        width = vim.o.columns > 160 and "90%" or 80,
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

  input:map("i", "<Esc>", function()
    layout:unmount()
  end)

  return layout
end

local termopen_git_diff = function(root, term, no_changes)
  vim.api.nvim_buf_call(term.bufnr, function()
    vim.fn.termopen(
      "git diff "
        .. (no_changes and "@^" or "--cached")
        .. " | delta --pager never"
        .. (vim.o.columns > 160 and " --side-by-side" or ""),
      {
        cwd = root,
        on_stdout = function()
          local first_visible_line_num = vim.fn.line("w0", term.winid)

          if
            first_visible_line_num
            and vim.api.nvim_buf_get_lines(
                term.bufnr,
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
  return vim.system({ "sh", "-c", cmd }, { cwd = LazyVim.root() }):wait().code
end

local git_commit = function(git_command, default_message)
  local Popup = require("nui.popup")
  local root = LazyVim.root()
  local origin_url = util.git_stdout({ "remote", "get-url", "origin" })
  local is_thebengeu_repo = origin_url and origin_url:match("thebengeu")

  if not is_thebengeu_repo then
    local default_branch = util.git_stdout({ "default-branch" })
    local current_branch = util.git_stdout({ "branch", "--show-current" })

    if current_branch == default_branch then
      local new_branch_name = vim.fn.input("New branch name: ", "beng/")

      if new_branch_name == "" then
        return
      end

      if
        util.sync_run({ "git", "switch", "--create", new_branch_name }).code
        ~= 0
      then
        return
      end
    end
  end

  local has_staged = system_sh_code("git diff --cached --quiet") ~= 0
  local no_changes = not has_staged
    and system_sh_code("git add --all && git diff --cached --quiet") == 0

  if no_changes and not default_message then
    vim.notify("No changes found", vim.log.levels.WARN)
    return
  end

  local input = setup_input(
    is_thebengeu_repo,
    root,
    not has_staged and not no_changes,
    git_command,
    default_message
  )
  local term = Popup(popup_options("Diff"))
  local layout = setup_layout(input, term)

  layout:mount()
  termopen_git_diff(root, term, no_changes)
end

vim.keymap.set("n", "<leader>k", function()
  vim.cmd.update()
  git_commit("commit")
end, { desc = "Commit" })

vim.keymap.set("n", "<leader>gA", function()
  vim.cmd.update()

  LazyVim.pick("git_commits", {
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
  })()
end, { desc = "Amend Selected Commit" })

vim.keymap.set("n", "<leader>ga", function()
  vim.cmd.update()
  git_commit(
    "commit --amend",
    util.git_stdout({ "show", "--format=%s", "--no-patch" })
  )
end, { desc = "Amend" })
