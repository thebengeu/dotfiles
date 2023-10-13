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
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    ft = "nu",
    opts = {},
  },
  {
    "vuki656/package-info.nvim",
    ft = "json",
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
