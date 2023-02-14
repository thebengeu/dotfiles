vim.keymap.set(
  "n",
  "<leader>ga",
  [[<Cmd>update | exec ":!git commit -a -m '" . input("") . "'" | AsyncRun -mode=term -pos=hide git push<CR>]],
  { desc = "Git commit all" }
)
vim.keymap.set(
  "n",
  "<leader>gC",
  [[<Cmd>update | exec ":!git commit -m '" . input("") . "'" | AsyncRun -mode=term -pos=hide git push<CR>]],
  { desc = "Git commit" }
)
vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")
