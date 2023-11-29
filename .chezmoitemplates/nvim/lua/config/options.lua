local util = require("util")

vim.api.nvim_create_user_command("Search", function(opts)
  util.open_url("https://www.google.com/search?q=" .. opts.fargs[1])
end, { nargs = 1 })

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.root_spec = { ".git", "cwd" }

vim.opt.fillchars = { eob = " " }
vim.opt.gdefault = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
vim.opt.keywordprg = ":Search"
vim.opt.linebreak = true
vim.opt.report = 999
vim.opt.sessionoptions = {
  "curdir",
  "winsize",
}

if jit.os == "Windows" then
  vim.opt.shell = "sh"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellxquote = ""
end

vim.opt.title = true
vim.opt.titlestring = (vim.env.TITLE_PREFIX or "") .. "%F"
vim.opt.winblend = 5
vim.opt.wrap = true

if vim.g.vscode then
  vim.api.nvim_create_user_command("LazyPlugins", function()
    local plugins = util.map(require("lazy").plugins(), function(plugin)
      return plugin.name
    end)

    table.sort(plugins)

    print(table.concat(plugins, ", "))
  end, {})
else
  vim.opt.scrolloff = 999
end
