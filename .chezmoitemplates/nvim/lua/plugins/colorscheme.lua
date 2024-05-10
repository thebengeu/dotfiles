local util = require("util")

local rainbow_delimiter_highlights = function(colors)
  local highlights = {}

  for i, color in ipairs(colors) do
    highlights[util.rainbow_delimiters_hl[i]] = { fg = color }
  end

  return highlights
end

return util.map({
  { "ribru17/bamboo.nvim" },
  {
    "uloco/bluloco.nvim",
    dependencies = "rktjmp/lush.nvim",
    highlights = function()
      return rainbow_delimiter_highlights({
        vim.g.terminal_color_1,
        vim.g.terminal_color_11,
        vim.g.terminal_color_4,
        vim.g.terminal_color_3,
        vim.g.terminal_color_2,
        vim.g.terminal_color_5,
        vim.g.terminal_color_6,
      })
    end,
    opts = {
      italics = true,
      terminal = true,
    },
  },
  {
    "catppuccin",
    colors_names = {
      "catppuccin-frappe",
      "catppuccin-macchiato",
      "catppuccin-mocha",
    },
    opts = {
      integrations = {
        dap = {
          enable_ui = true,
          enabled = true,
        },
        rainbow_delimiters = true,
      },
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    opts = {
      italic_comments = true,
    },
  },
  {
    "Mofiqul/dracula.nvim",
    colors_names = {
      "dracula",
      "dracula-soft",
    },
    opts = {
      italic_comment = true,
    },
  },
  {
    "sainnhe/edge",
    colorscheme_styles = {
      "aura",
      "default",
      "neon",
    },
    config = function()
      vim.g.edge_better_performance = 1
      vim.g.edge_enable_italic = 1
    end,
  },
  {
    "Everblush/nvim",
    highlights = function()
      local palette = require("everblush.palette")

      return rainbow_delimiter_highlights({
        palette.color1,
        palette.color3,
        palette.color4,
        palette.color7,
        palette.color2,
        palette.color5,
        palette.color6,
      })
    end,
    name = "everblush",
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
    "maxmx03/fluoromachine.nvim",
    opts = {
      overrides = function(colors)
        return rainbow_delimiter_highlights({
          colors.red,
          colors.yellow,
          colors.pink,
          colors.orange,
          colors.green,
          colors.purple,
          colors.cyan,
        })
      end,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = function()
      local gruvbox = require("gruvbox")

      return {
        overrides = {
          TSRainbowCyan = { fg = gruvbox.palette.neutral_blue },
        },
      }
    end,
  },
  { "luisiacc/gruvbox-baby" },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    colors_names = {
      "kanagawa-dragon",
      "kanagawa-wave",
    },
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
    colorscheme_styles = {
      "darker",
      "deep ocean",
      "oceanic",
      "palenight",
    },
    opts = {
      async_loading = false,
      plugins = {
        "dap",
        "eyeliner",
        "flash",
        "gitsigns",
        "harpoon",
        "illuminate",
        "indent-blankline",
        "mini",
        "neo-tree",
        "neogit",
        "noice",
        "nvim-cmp",
        "nvim-notify",
        "nvim-web-devicons",
        "rainbow-delimiters",
        "telescope",
        "trouble",
        "which-key",
      },
      styles = {
        comments = { italic = true },
      },
    },
  },
  {
    "savq/melange-nvim",
    highlights = function()
      local palette = require("melange.palettes.dark")

      return rainbow_delimiter_highlights({
        palette.b.red,
        palette.b.yellow,
        palette.b.blue,
        palette.c.yellow,
        palette.b.green,
        palette.b.magenta,
        palette.b.cyan,
      })
    end,
  },
  {
    "dasupradyumna/midnight.nvim",
    opts = function()
      local components = require("midnight.colors").components

      return rainbow_delimiter_highlights({
        components.operator,
        components.method,
        components.constant,
        components.string,
        components.field,
        components.keyword,
        components.parameter,
      })
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    colors_names = {
      "monokai-pro",
      "monokai-pro-classic",
      "monokai-pro-machine",
      "monokai-pro-octagon",
      "monokai-pro-ristretto",
      "monokai-pro-spectrum",
    },
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
  },
  {
    "Tsuzat/NeoSolarized.nvim",
    opts = {
      transparent = false,
    },
  },
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
  },
  {
    "EdenEast/nightfox.nvim",
    colors_names = {
      "carbonfox",
      "duskfox",
      "nightfox",
      "nordfox",
      "terafox",
    },
    opts = {
      options = {
        styles = {
          comments = "italic",
        },
      },
    },
  },
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
  { "cpea2506/one_monokai.nvim" },
  {
    "olimorris/onedarkpro.nvim",
    colors_names = {
      "onedark",
      "onedark_dark",
      "onedark_vivid",
    },
    opts = {
      styles = {
        comments = "italic",
      },
    },
  },
  {
    "rmehri01/onenord.nvim",
    opts = {
      styles = {
        comments = "italic",
      },
    },
  },
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
  {
    colors_names = {
      "selenized-black",
      "selenized-dark",
      "solarized-dark",
    },
    highlights = function()
      local highlights = {}

      for _, color in ipairs(util.rainbow_colors) do
        highlights["RainbowDelimiter" .. color] = { link = "Rainbow" .. color }
      end

      return highlights
    end,
    url = "https://gitlab.com/HiPhish/resolarized.nvim.git",
  },
  {
    "craftzdog/solarized-osaka.nvim",
    opts = {
      transparent = false,
    },
  },
  {
    "sainnhe/sonokai",
    colorscheme_styles = {
      "andromeda",
      "atlantis",
      "default",
      "espresso",
      "maia",
      "shusia",
    },
    config = function()
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
    end,
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      custom_highlights = function(_, palette)
        return rainbow_delimiter_highlights({
          palette.red,
          palette.yellow,
          palette.blue,
          palette.orange,
          palette.green,
          palette.purple,
          palette.cyan,
        })
      end,
    },
  },
  {
    "folke/tokyonight.nvim",
    colors_names = {
      "tokyonight-moon",
      "tokyonight-night",
      "tokyonight-storm",
    },
  },
  {
    "sam4llis/nvim-tundra",
    opts = {
      plugins = {
        cmp = true,
        context = true,
        gitsigns = true,
        neogit = true,
        telescope = true,
      },
      syntax = {
        comments = { italic = true },
      },
    },
    highlights = function()
      local colors = require("nvim-tundra.palette.arctic")

      if not colors then
        error()
      end

      return rainbow_delimiter_highlights({
        colors.red._500,
        colors.sand._500,
        colors.sky._500,
        colors.orange._500,
        colors.green._500,
        colors.indigo._500,
        colors.opal._500,
        colors.cyan,
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    opts = {
      italic_comments = true,
    },
  },
}, function(colorscheme_spec)
  local extra_spec = {}

  for _, key in ipairs({ "colors_names", "colorscheme_styles", "highlights" }) do
    extra_spec[key] = colorscheme_spec[key]
    colorscheme_spec[key] = nil
  end

  if next(extra_spec) then
    util.extra_specs[colorscheme_spec[1] or colorscheme_spec.url] = extra_spec
  end

  colorscheme_spec.lazy = true
  colorscheme_spec.priority = 1000
  return colorscheme_spec
end)
