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
    "fladson/vim-kitty",
    ft = "kitty",
  },
}
