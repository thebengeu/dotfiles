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
  {
    "catppuccin/nvim",
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
    name = "catppuccin",
    priority = 1000,
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    opts = {},
  },
})
