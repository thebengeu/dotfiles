vim.api.nvim_create_user_command("Search", function(opts)
  vim.fn.system("start https://www.google.com/search?q=" .. opts.fargs[1])
end, { nargs = 1 })

vim.g.db = "postgresql://postgres:postgres@localhost:5432/postgres"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.keywordprg = ":Search"
vim.opt.linebreak = true
vim.opt.mouse = ""
vim.opt.report = 999
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "localoptions",
  "tabpages",
  "winpos",
  "winsize",
}

if jit.os:find("Windows") then
  vim.opt.shell = "sh"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellxquote = ""
end

vim.opt.title = true
vim.opt.titlestring = "%F"
vim.opt.wrap = true
