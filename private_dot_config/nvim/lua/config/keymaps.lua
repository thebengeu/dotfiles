vim.keymap.set(
  "n",
  "<leader>ga",
  [[<Cmd>exec ":!git commit -a -m '" . input("") . "'" | AsyncRun -mode=term -pos=hide git push<CR>]],
  { desc = "Git commit all" }
)
