local util = require("util")

vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")

vim.keymap.set("n", "<leader>gP", function()
  util.async_run({ "git", "push" })
end, { desc = "Push" })

vim.keymap.set("n", "<leader>gp", function()
  util.async_run({ "git", "pull" })
end, { desc = "Pull" })

vim.keymap.set("n", "<leader>gw", function()
  util.async_run({ "git", "wip" })
end, { desc = "Commit WIP" })

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
vim.keymap.set("n", "dd", function()
  return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { desc = "Line", expr = true })

vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")

vim.keymap.set("n", "<leader>cu", function()
  util.async_run_sh(
    "chezmoi update --apply=false; chezmoi init; chezmoi apply --exclude scripts; chezmoi apply --include scripts"
  )
end, { desc = "Chezmoi update" })

-- https://nanotipsforvim.prose.sh/repeated-v-in-visual-line-mode
vim.keymap.set("x", "V", "j")

vim.keymap.set({ "i", "n" }, "<C-_>", "<C-/>", { remap = true })

if vim.g.goneovim or vim.g.neovide then
  vim.keymap.set("n", "<C-v>", "a<C-r>+<Esc>")
  vim.keymap.set({ "c", "i" }, "<C-v>", "<C-r>+")
end

require("config.keymaps_git_commit")
