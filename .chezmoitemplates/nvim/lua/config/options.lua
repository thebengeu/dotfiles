vim.api.nvim_create_user_command("Search", function(opts)
  vim.system(vim.list_extend(jit.os == "Windows" and {
    vim.env["ProgramFiles(x86)"] .. "/Microsoft/Edge/Application/msedge.exe",
  } or (vim.fn.executable("wslview") == 1 and { "wslview" } or {
    "lmn",
    "open",
  }), { "https://www.google.com/search?q=" .. opts.fargs[1] }))
end, { nargs = 1 })

vim.g.db = "postgresql://postgres:postgres@localhost:5432/postgres"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.concealcursor = "cinv"
vim.opt.gdefault = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
vim.opt.keywordprg = ":Search"
vim.opt.linebreak = true
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
vim.opt.swapfile = false

if jit.os == "Windows" then
  vim.opt.shell = "sh"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellxquote = ""
end

vim.opt.title = true
vim.opt.titlestring = (vim.env.TITLE_PREFIX or "") .. "%F"
vim.opt.wrap = true
