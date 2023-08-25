vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if vim.fn.getline("."):find("^%s*,%s*$") then
      vim.cmd.undojoin()
      vim.fn.deletebufline("", vim.fn.line("."))
    end
  end,
  pattern = "*.lua",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "AsyncRun -close -mode=term -rows=5 chezmoi apply --init",
  pattern = "*/.local/share/chezmoi/*",
})
if os.getenv("TMUX") ~= nil then
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    command = 'call system("tmux rename-window " . expand("%:p"))',
  })
end
vim.api.nvim_create_autocmd("BufEnter", {
  command = "startinsert",
  pattern = "term://*",
})
