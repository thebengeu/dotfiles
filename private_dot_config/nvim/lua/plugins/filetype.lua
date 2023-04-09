local g = vim.g

return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  { "alker0/chezmoi.vim" },
  {
    "GCBallesteros/jupytext.vim",
    config = function()
      g.jupytext_fmt = "py"
      g.jupytext_style = ":hydrogen"
    end,
    enabled = false,
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
    "Glench/Vim-Jinja2-Syntax",
    enabled = false,
  },
}
