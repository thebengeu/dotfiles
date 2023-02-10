vim.keymap.set(
  "n",
  "<leader>gC",
  [[<Cmd>exec ":!git commit -a -m '" . input("") . "'"<CR>]],
  { desc = "Git commit all" }
)
