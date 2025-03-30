local util = require("util")

vim.api.nvim_create_user_command("Search", function(opts)
  util.open_url("https://www.google.com/search?q=" .. opts.fargs[1])
end, { nargs = 1 })

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.root_spec = {
  ".git",
  "cwd",
}
vim.g.snacks_animate = false

vim.opt.fillchars = { eob = " " }
vim.opt.gdefault = true
vim.opt.guifont = "MonoLisa Variable:h" .. (jit.os == "OSX" and "17" or "13")
vim.opt.keywordprg = ":Search"
vim.opt.linebreak = true
vim.opt.pumblend = 10
vim.opt.report = 999
vim.opt.sessionoptions = {
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
vim.opt.winblend = 10
vim.opt.wrap = true

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
  pattern = {
    [".*bigqueryrc"] = "dosini",
    [".*sqlfluff"] = "cfg",
    [".*wslconfig"] = "dosini",
  },
})

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_density = 50
  vim.g.neovide_cursor_vfx_particle_lifetime = 2
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_underline_stroke_scale = 2.5
end

if vim.g.vscode then
  vim.api.nvim_create_user_command("LazyPlugins", function()
    local plugins = vim
      .iter(require("lazy").plugins())
      :map(function(plugin)
        return plugin.name
      end)
      :totable()

    table.sort(plugins)

    print(table.concat(plugins, "\n"))
  end, {})
end
