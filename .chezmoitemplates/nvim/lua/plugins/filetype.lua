return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  {
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
  {
    "kmonad/kmonad-vim",
    ft = "kbd",
  },
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    dependencies = "nvim-treesitter/nvim-treesitter",
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
