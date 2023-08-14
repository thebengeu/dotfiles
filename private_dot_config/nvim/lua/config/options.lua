-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.db = "postgresql://postgres:postgres@localhost:5432/postgres"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.o.report = 999
vim.o.sessionoptions = table.concat({
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "localoptions",
  "tabpages",
  "winpos",
  "winsize",
}, ",")
vim.opt.linebreak = true
vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-Command"
vim.opt.wrap = true
