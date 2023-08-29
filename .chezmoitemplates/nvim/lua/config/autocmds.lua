local async_run = require("util").async_run

vim.api.nvim_create_autocmd("BufEnter", {
  command = "startinsert",
  pattern = "term://*",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = async_run("chezmoi apply --init"),
  pattern = "*/.local/share/chezmoi/*",
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if vim.fn.getline("."):find("^%s*,%s*$") then
      vim.cmd.undojoin()
      vim.fn.deletebufline("", vim.fn.line("."))
    end
  end,
  pattern = "*.lua",
})

if os.getenv("TMUX") ~= nil then
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    callback = function()
      vim.fn.system("tmux rename-window " .. vim.fn.expand("%:p"):gsub(os.getenv("HOME") or "", "~"))
    end,
  })
end
