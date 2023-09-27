local Input = require("nui.input")
local Layout = require("nui.layout")
local Popup = require("nui.popup")
local util = require("util")

vim.keymap.del("x", "j")
vim.keymap.del("x", "k")

vim.keymap.set(
  "n",
  "<leader>bo",
  "<Cmd>%bd|e#|bd#<CR>",
  { desc = "Delete other buffers" }
)

local delete_trailing_blank_lines = function(bufnr)
  while vim.api.nvim_buf_get_lines(bufnr, -2, -1, true)[1] == "" do
    vim.api.nvim_buf_set_lines(bufnr, -2, -1, true, {})
  end
end

vim.keymap.set("n", "<leader>k", function()
  if
    vim
      .system({
        "sh",
        "-c",
        "git diff --cached --quiet && git add --all && git diff --cached --quiet",
      })
      :wait().code == 0
  then
    vim.notify("No changes found", vim.log.levels.WARN)
    return
  end

  local current_bufnr = vim.fn.bufnr("%")
  vim.cmd.bufdo("update")
  vim.api.nvim_set_current_buf(current_bufnr --[[@as integer]])

  local input = Input({ border = "single" }, {
    on_submit = function(commit_summary)
      if commit_summary ~= "" then
        util.async_run({
          "sh",
          "-c",
          "git commit -"
            .. 'm "'
            .. commit_summary:gsub('"', '\\"')
            .. '" && git push',
        })
      end
    end,
    prompt = "Commit summary: ",
  })

  local unmount = input.unmount
  input.unmount = function(self)
    if self._.loading then
      return
    end

    unmount(self)
  end

  local term = Popup({ border = "single" })

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
      vim.fn.win_execute(term.winid, 'execute "normal \\' .. ctrl_key .. '"')
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

  layout:mount()

  local term_bufnr = term.bufnr

  vim.api.nvim_buf_call(term_bufnr, function()
    vim.fn.termopen("git diff --cached | delta --pager never", {
      on_exit = function()
        local interval = 10
        local timer = vim.uv.new_timer()

        timer:start(
          interval,
          interval,
          vim.schedule_wrap(function()
            if vim.api.nvim_buf_is_valid(term_bufnr) then
              vim.api.nvim_buf_set_option(term_bufnr, "modifiable", true)

              delete_trailing_blank_lines(term_bufnr)

              if
                vim.api.nvim_buf_get_lines(term_bufnr, -2, -1, true)[1]
                ~= "[Process exited 0]"
              then
                return
              end

              vim.api.nvim_buf_set_lines(term_bufnr, -2, -1, true, {})

              delete_trailing_blank_lines(term_bufnr)

              vim.api.nvim_buf_set_option(term_bufnr, "modifiable", false)
            end

            timer:close()
          end)
        )
      end,
    })
  end)
end, { desc = "Git commit" })

vim.keymap.set("n", "<leader>gP", function()
  util.async_run({ "git", "push" })
end, { desc = "Git push" })

vim.keymap.set("n", "<leader>gp", function()
  util.async_run({ "git", "pull" })
end, { desc = "Git pull" })

vim.keymap.set("n", "<leader>gw", function()
  util.async_run({ "git", "wip" })
end, { desc = "Git commit WIP" })

vim.keymap.set("n", "<leader>um", function()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.mouse = vim.opt.mouse:get().a and "" or "a"
end, { desc = "Toggle Mouse" })

vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")

vim.keymap.set("n", "[<Space>", function()
  vim.fn.append(vim.fn.line(".") - 1, "")
end, { desc = "Add blank line above" })

vim.keymap.set("n", "]<Space>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.append(vim.fn.line("."), "")
end, { desc = "Add blank line below" })

-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "dd", function()
  return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")

vim.keymap.set("n", "<leader>cu", function()
  util.async_run({
    "sh",
    "-c",
    "chezmoi update --apply=false; chezmoi init; chezmoi apply --exclude scripts; chezmoi apply --include scripts",
  })
end, { desc = "Chezmoi update" })

-- https://nanotipsforvim.prose.sh/repeated-v-in-visual-line-mode
vim.keymap.set("x", "V", "j")

if vim.g.goneovim or vim.g.neovide then
  vim.keymap.set("n", "<C-v>", "a<C-r>+<Esc>")
  vim.keymap.set({ "c", "i" }, "<C-v>", "<C-r>+")
end
