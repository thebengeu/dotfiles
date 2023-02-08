vim.api.nvim_create_autocmd("BufWritePost", {
  command = "!chezmoi apply --source-path <afile>",
  pattern = "*/.local/share/chezmoi/*",
})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  command = 'call system("tmux rename-window " . expand("%:p"))',
})
