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
    config = true,
    ft = "nu",
  },
  {
    "vuki656/package-info.nvim",
    config = true,
    ft = "json",
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
