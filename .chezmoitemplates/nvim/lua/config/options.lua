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
vim.opt.wrap = true

if jit.os:find("Windows") then
  vim.o.shell = "sh"
  vim.o.shellcmdflag = "-c"
  vim.o.shellxquote = ""
end

vim.api.nvim_create_user_command("Search", function(opts)
  vim.fn.system("start https://www.google.com/search?q=" .. opts.fargs[1])
end, { nargs = 1 })

vim.o.keywordprg = ":Search"
