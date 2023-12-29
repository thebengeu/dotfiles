return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  {
    "alker0/chezmoi.vim",
    cond = vim.loop.cwd():match("chezmoi") ~= nil,
  },
  {
    "kmonad/kmonad-vim",
    ft = "kbd",
  },
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    ft = "nu",
    opts = {},
  },
  {
    "blankname/vim-fish",
    ft = "fish",
  },
  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },
}
