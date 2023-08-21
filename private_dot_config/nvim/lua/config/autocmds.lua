vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if string.find(vim.fn.getline("."), "^%s*,%s*$") then
      vim.cmd.undojoin()
      vim.fn.deletebufline("", vim.fn.line("."))
    end
  end,
  pattern = "*.lua",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "AsyncRun -mode=term -pos=hide chezmoi apply --source-path <afile>",
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
