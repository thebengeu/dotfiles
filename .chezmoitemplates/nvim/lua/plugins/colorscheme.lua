local util = require("util")

local rainbow_delimiter_highlights = function(colors)
  local highlights = {}

  for i, color in ipairs(colors) do
    highlights[util.rainbow_delimiters_hl[i]] = { fg = color }
  end

  return highlights
end

return util.map({
  {
    "ribru17/bamboo.nvim",
    colors_names = {
      "bamboo-multiplex",
      "bamboo-vulgaris",
    },
    colors_names_light = {
      "bamboo-light",
    },
    opts = {},
  },
  {
    "uloco/bluloco.nvim",
    dependencies = "rktjmp/lush.nvim",
    opts = {
      italics = true,
      terminal = true,
    },
    supports_light_background = true,
  },
  {
    "catppuccin",
    colors_names = {
      "catppuccin-frappe",
      "catppuccin-macchiato",
      "catppuccin-mocha",
    },
    colors_names_light = {
      "catppuccin-latte",
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
      variant = "auto",
    },
    supports_light_background = true,
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
      "light",
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
    supports_light_background = true,
  },
  { "comfysage/evergarden" },
  {
    "0xstepit/flow.nvim",
    highlights = function()
      local colors = require("flow.colors").colors

      return rainbow_delimiter_highlights({
        colors.red,
        colors.yellow,
        colors.blue,
        colors.yellow,
        colors.green,
        colors.purple,
        colors.cyan,
      })
    end,
    opts = {},
  },
  {
    "maxmx03/fluoromachine.nvim",
    opts = function()
      local themes = { "delta", "fluoromachine", "retrowave" }

      return {
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
        styles = {
          comments = {
            italic = true,
          },
        },
        theme = themes[math.random(#themes)],
      }
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    colors_names = {
      "github_dark",
      "github_dark_default",
      "github_dark_dimmed",
      "github_dark_high_contrast",
    },
    colors_names_light = {
      "github_light",
      "github_light_default",
      "github_light_high_contrast",
    },
    name = "github-theme",
    opts = function()
      return {
        groups = {
          all = rainbow_delimiter_highlights({
            "palette.red",
            "palette.yellow",
            "palette.blue",
            "palette.orange",
            "palette.green",
            "palette.magenta",
            "palette.cyan",
          }),
        },
        options = {
          styles = {
            comments = "italic",
          },
        },
      }
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    supports_light_background = true,
  },
  { "luisiacc/gruvbox-baby" },
  {
    "sainnhe/gruvbox-material",
    colorscheme_styles = {
      "material",
      "mix",
      "original",
    },
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
    end,
    supports_light_background = true,
  },
  {
    "rebelot/kanagawa.nvim",
    colors_names = {
      "kanagawa-dragon",
      "kanagawa-wave",
    },
    colors_names_light = {
      "kanagawa-lotus",
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
  { "sho-87/kanagawa-paper.nvim" },
  {
    "marko-cerovac/material.nvim",
    colorscheme_styles = {
      "darker",
      "deep ocean",
      "lighter",
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
        "indent-blankline",
        "mini",
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
      local palette = require("melange.palettes." .. vim.o.background)

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
    supports_light_background = true,
  },
  {
    "ramojus/mellifluous.nvim",
    colorscheme_styles = {
      "alduin",
      "kanagawa_dragon",
      "mellifluous",
      "mountain",
      "tender",
    },
    opts = function()
      local highlight_overrides = function(highlighter, colors)
        highlighter.set("RainbowDelimiterRed", { fg = colors.red })
        highlighter.set("RainbowDelimiterYellow", { fg = colors.yellow })
        highlighter.set("RainbowDelimiterBlue", { fg = colors.blue })
        highlighter.set("RainbowDelimiterOrange", { fg = colors.orange })
        highlighter.set("RainbowDelimiterGreen", { fg = colors.green })
        highlighter.set("RainbowDelimiterViolet", { fg = colors.purple })
        highlighter.set(
          "RainbowDelimiterCyan",
          { fg = colors.cyan or colors.blue }
        )
      end

      return {
        color_set = util.colorscheme_style,
        highlight_overrides = {
          dark = highlight_overrides,
          light = highlight_overrides,
        },
      }
    end,
  },
  {
    "mellow-theme/mellow.nvim",
    config = function()
      local colors = require("mellow.colors").dark

      vim.g.mellow_highlight_overrides = rainbow_delimiter_highlights({
        colors.red,
        colors.yellow,
        colors.blue,
        colors.bright_yellow,
        colors.green,
        colors.magenta,
        colors.cyan,
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
    "echasnovski/mini.base16",
    colors_names = {
      "minicyan",
      "minischeme",
    },
    supports_light_background = true,
  },
  {
    "polirritmico/monokai-nightasty.nvim",
    supports_light_background = true,
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
    colors_names_light = {
      "monokai-pro-light",
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
    supports_light_background = true,
  },
  {
    "yorik1984/newpaper.nvim",
    colorscheme_styles = {
      "dark",
      "light",
    },
    opts = {},
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
    colors_names_light = {
      "dawnfox",
      "dayfox",
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
    "oxfist/night-owl.nvim",
    highlights = function()
      local palette = require("night-owl.palette")

      return rainbow_delimiter_highlights({
        palette.red,
        palette.yellow,
        palette.blue15,
        palette.orange,
        palette.green,
        palette.purple3,
        palette.cyan,
      })
    end,
    opts = {},
  },
  { "gbprod/nord.nvim" },
  {
    "AlexvZyl/nordic.nvim",
    opts = {
      on_highlight = function(highlights, palette)
        highlights.RainbowDelimiterViolet = { fg = palette.magenta.bright }
        highlights.RainbowDelimiterCyan = { fg = palette.cyan.bright }
      end,
    },
  },
  { "dgox16/oldworld.nvim" },
  { "cpea2506/one_monokai.nvim" },
  {
    "olimorris/onedarkpro.nvim",
    colors_names = {
      "onedark",
      "onedark_dark",
      "onedark_vivid",
    },
    colors_names_light = {
      "onelight",
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
    supports_light_background = true,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    highlights = function()
      local oxocarbon = require("oxocarbon").oxocarbon

      return rainbow_delimiter_highlights({
        oxocarbon.base09,
        oxocarbon.base10,
        oxocarbon.base11,
        oxocarbon.base12,
        oxocarbon.base13,
        oxocarbon.base14,
        oxocarbon.base15,
      })
    end,
  },
  {
    "rose-pine/neovim",
    colors_names = {
      "rose-pine-main",
      "rose-pine-moon",
    },
    colors_names_light = {
      "rose-pine-dawn",
    },
    name = "rose-pine",
  },
  {
    "craftzdog/solarized-osaka.nvim",
    opts = {
      transparent = false,
    },
    supports_light_background = true,
  },
  {
    "maxmx03/solarized.nvim",
    opts = {
      on_highlights = function(colors)
        return {
          RainbowDelimiterYellow = { fg = colors.yellow },
        }
      end,
    },
    supports_light_background = true,
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
    colors_names_light = {
      "tokyonight-day",
    },
  },
  {
    "sam4llis/nvim-tundra",
    colorscheme_styles = {
      "arctic",
      "jungle",
    },
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
    highlights = function(style)
      local colors = require("nvim-tundra.palette." .. style)

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
    highlights = function()
      local colors = require("vscode.colors").get_colors()

      return {
        RainbowDelimiterBlue = { fg = colors.vscMediumBlue or colors.vscBlue },
      }
    end,
    opts = {
      italic_comments = true,
    },
    supports_light_background = true,
  },
  {
    "mcchrish/zenbones.nvim",
    colors_names = {
      "zenburned",
    },
    highlights = function()
      local palette = require(vim.g.colors_name .. ".palette")

      return rainbow_delimiter_highlights({
        palette.dark.rose.hex,
        palette.dark.wood.hex,
        palette.dark.water.hex,
        palette.dark.fg.hex,
        palette.dark.leaf.hex,
        palette.dark.blossom.hex,
        palette.dark.sky.hex,
      })
    end,
  },
}, function(colorscheme_spec)
  local extra_spec = {}

  for _, key in ipairs({
    "colors_names",
    "colors_names_light",
    "colorscheme_styles",
    "highlights",
    "supports_light_background",
  }) do
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
