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
vim.keymap.set("n", "<leader>gP", [[<Cmd>AsyncRun -mode=term -pos=hide git push<CR>]], { desc = "Git push" })
vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")
vim.keymap.set("n", "<space>bo", "<Cmd>%bd|e#|bd#<CR>", { desc = "Delete other buffers" })
vim.keymap.set(
  "n",
  "[<space>",
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  { desc = "Add blank lines above" }
)
vim.keymap.set(
  "n",
  "]<space>",
  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  { desc = "Add blank lines below" }
)
