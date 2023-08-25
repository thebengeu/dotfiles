vim.keymap.set(
  "n",
  "<leader>ga",
  [[<Cmd>update | exec ":!git commit -a -m '" . input("") . "'" | AsyncRun -close -mode=term -rows=5 git push<CR>]],
  { desc = "Git commit all" }
)
vim.keymap.set(
  "n",
  "<leader>gC",
  [[<Cmd>update | exec ":!git commit -m '" . input("") . "'" | AsyncRun -close -mode=term -rows=5 git push<CR>]],
  { desc = "Git commit" }
)
vim.keymap.set("n", "<leader>gP", [[<Cmd>AsyncRun -close -mode=term -rows=5 git push<CR>]], { desc = "Git push" })
vim.keymap.set("n", "<leader>gp", [[<Cmd>AsyncRun -close -mode=term -rows=5 git pull<CR>]], { desc = "Git pull" })
vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")
vim.keymap.set("n", "<space>bo", "<Cmd>%bd|e#|bd#<CR>", { desc = "Delete other buffers" })
vim.keymap.del("x", "j")
vim.keymap.del("x", "k")
vim.keymap.set("n", "<space>cs", function()
  vim.cmd("edit " .. vim.fn.system({ "chezmoi", "source-path", vim.api.nvim_buf_get_name(0) }))
end, { desc = "Chezmoi Source" })
vim.keymap.set("n", "<space>ct", function()
  vim.cmd("edit " .. vim.fn.system({ "chezmoi", "target-path", vim.api.nvim_buf_get_name(0) }))
end, { desc = "Chezmoi Target" })
