local map = require("util").map

local rainbow_delimiter_colors = {
  "Red",
  "Yellow",
  "Blue",
  "Orange",
  "Green",
  "Violet",
  "Cyan",
}
local rainbow_delimiter_highlights = function(colors)
  local highlights = {}

  for i, color in ipairs(colors) do
    highlights["RainbowDelimiter" .. rainbow_delimiter_colors[i]] = { fg = color }
  end

  return highlights
end

local create_colorscheme_autocmds = function(colors_names, get_highlights)
  return function()
    for _, colors_name in ipairs(type(colors_names) == "table" and colors_names or { colors_names }) do
      local callback = function()
        for name, highlight in pairs(rainbow_delimiter_highlights(get_highlights(colors_name))) do
          vim.api.nvim_set_hl(0, name, highlight)
        end
      end

      if vim.g.colors_name == colors_name then
        callback()
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = callback,
        pattern = colors_name,
      })
    end
  end
end

return map({
  { "ribru17/bamboo.nvim" },
  {
    "uloco/bluloco.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    opts = {
      italics = true,
    },
  },
  {
    "catppuccin",
    opts = {
      integrations = {
        dap = {
          enable_ui = true,
          enabled = true,
        },
        treesitter_context = true,
        ts_rainbow = true,
      },
    },
  },
  { "Mofiqul/dracula.nvim" },
  {
    "sainnhe/edge",
    config = function()
      vim.g.edge_better_performance = 1
      vim.g.edge_enable_italic = 1
    end,
  },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_better_performance = 1
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 1
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    opts = {
      groups = {
        all = rainbow_delimiter_highlights({
          "palette.red",
          "palette.yellow",
          "palette.blue",
          "palette.pink",
          "palette.green",
          "palette.magenta",
          "palette.cyan",
        }),
      },
    },
    main = "github-theme",
  },
  { "ellisonleao/gruvbox.nvim" },
  { "luisiacc/gruvbox-baby" },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_foreground = "original"
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      overrides = function(colors)
        return rainbow_delimiter_highlights({
          colors.palette.peachRed,
          colors.palette.carpYellow,
          colors.palette.crystalBlue,
          colors.palette.surimiOrange,
          colors.palette.springGreen,
          colors.palette.oniViolet,
          colors.palette.waveAqua2,
        })
      end,
    },
  },
  {
    "marko-cerovac/material.nvim",
    init = create_colorscheme_autocmds("material", function()
      local colors = require("material.colors")

      return {
        colors.main.red,
        colors.main.yellow,
        colors.main.blue,
        colors.main.orange,
        colors.main.green,
        colors.main.purple,
        colors.main.cyan,
      }
    end),
    opts = {
      plugins = {
        "dap",
        "gitsigns",
        "indent-blankline",
        "mini",
        "nvim-cmp",
        "nvim-navic",
        "nvim-web-devicons",
        "telescope",
        "trouble",
        "which-key",
      },
    },
  },
  { "echasnovski/mini.base16" },
  { "bluz71/vim-moonfly-colors" },
  { "bluz71/vim-nightfly-colors" },
  { "EdenEast/nightfox.nvim" },
  {
    "AlexvZyl/nordic.nvim",
    opts = function()
      local colors = require("nordic.colors")

      return {
        override = rainbow_delimiter_highlights({
          colors.red.base,
          colors.yellow.base,
          colors.blue0,
          colors.orange.base,
          colors.green.base,
          colors.magenta.base,
          colors.cyan.base,
        }),
      }
    end,
  },
  {
    "sam4llis/nvim-tundra",
    init = create_colorscheme_autocmds("tundra", function()
      local colors = require("nvim-tundra.palette.arctic")

      if not colors then
        error()
      end

      return {
        colors.red._500,
        colors.sand._500,
        colors.sky._500,
        colors.orange._500,
        colors.green._500,
        colors.indigo._500,
        colors.opal._500,
        colors.cyan,
      }
    end),
    opts = {
      plugins = {
        cmp = true,
        gitsigns = true,
        neogit = true,
        telescope = true,
      },
    },
  },
  { "cpea2506/one_monokai.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "rmehri01/onenord.nvim" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      highlight_groups = rainbow_delimiter_highlights({
        "love",
        "gold",
        "pine",
        "rose",
        "foam",
        "iris",
        "highlight_high",
      }),
    },
  },
  { "olivercederborg/poimandres.nvim" },
  {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
    end,
  },
  {
    "ray-x/starry.nvim",
    init = create_colorscheme_autocmds({
      "darker",
      "darksolar",
      "deepocean",
      "dracula",
      "dracula_blood",
      "earlysummer",
      "earlysummer_lighter",
      "emerald",
      "mariana",
      "mariana_lighter",
      "middlenight_blue",
      "monokai",
      "monokai_lighter",
      "moonlight",
      "oceanic",
      "palenight",
      "starry",
    }, function()
      local colors = require("starry.colors").color_table()

      return {
        colors.red,
        colors.yellow,
        colors.blue,
        colors.orange,
        colors.green,
        colors.purple,
        colors.cyan,
      }
    end),
  },
  {
    "Mofiqul/vscode.nvim",
    opts = function()
      local colors = require("vscode.colors").get_colors()

      return {
        group_overrides = rainbow_delimiter_highlights({
          colors.vscRed,
          colors.vscYellow,
          colors.vscBlue,
          colors.vscOrange,
          colors.vscGreen,
          colors.vscViolet,
          colors.vscBlueGreen,
        }),
      }
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    init = create_colorscheme_autocmds({
      "duckbones",
      "forestbones",
      "kanagawabones",
      "neobones",
      "nordbones",
      "rosebones",
      "seoulbones",
      "tokyobones",
      "zenbones",
      "zenburned",
      "zenwritten",
    }, function(colorscheme_name)
      local palette = require(colorscheme_name .. ".palette")

      return {
        palette.dark.rose.hex,
        palette.dark.wood.hex,
        palette.dark.water.hex,
        palette.dark.fg.hex,
        palette.dark.leaf.hex,
        palette.dark.blossom.hex,
        palette.dark.sky.hex,
      }
    end),
  },
}, function(colorscheme_spec)
  colorscheme_spec.lazy = true
  return colorscheme_spec
end)
