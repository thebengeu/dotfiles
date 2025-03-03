local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  concurrency = jit.os == "Windows" and (vim.uv.available_parallelism() * 2)
    or (jit.os == "OSX" and vim.fn.has("gui_running") == 1) and 111
    or nil,
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
  dev = {
    fallback = true,
    path = "~/thebengeu",
    patterns = { "friendly-snippets" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
