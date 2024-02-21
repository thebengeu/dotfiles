local Util = require("lazyvim.util")
local util = require("util")

vim.api.nvim_create_user_command("Search", function(opts)
  util.open_url("https://www.google.com/search?q=" .. opts.fargs[1])
end, { nargs = 1 })

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.root_spec = {
  function(buf)
    local bufpath = Util.root.bufpath(buf)

    return bufpath and bufpath:match(".*/supabase/apps/studio")
  end,
  ".git",
  "cwd",
}

vim.opt.fillchars = { eob = " " }
vim.opt.gdefault = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h"
  .. (jit.os == "OSX" and "18" or "14")
vim.opt.keywordprg = ":Search"
vim.opt.linebreak = true
vim.opt.report = 999
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "localoptions",
  "tabpages",
  "winpos",
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

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_density = 50
  vim.g.neovide_cursor_vfx_particle_lifetime = 2
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_transparency = 0.95

  vim.defer_fn(vim.cmd.NeovideFocus, 250)
end

if vim.g.vscode then
  vim.api.nvim_create_user_command("LazyPlugins", function()
    local plugins = util.map(require("lazy").plugins(), function(plugin)
      return plugin.name
    end)

    table.sort(plugins)

    print(table.concat(plugins, ", "))
  end, {})
end
