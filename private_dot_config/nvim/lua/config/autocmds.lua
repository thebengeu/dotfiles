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
  command = "!chezmoi apply --source-path <afile>",
  pattern = "*/.local/share/chezmoi/*",
})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  command = 'call system("tmux rename-window " . expand("%:p"))',
})
vim.api.nvim_create_autocmd("BufEnter", {
  command = "startinsert",
  pattern = "term://*",
})
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd("cclose")
    end
  end,
  pattern = "*.py",
})
