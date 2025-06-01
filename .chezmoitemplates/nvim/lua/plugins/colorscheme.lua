local util = require("util")

local rainbow_delimiter_highlights = function(colors, highlights)
  highlights = highlights or {}

  for i, color in ipairs(colors) do
    highlights[util.rainbow_delimiters_hl[i]] = { fg = color }
  end

  return highlights
end

-- Check rainbow delimiter support:
-- rg 'miniicons|rainbow' Everblush flow.nvim fluoromachine.nvim jellybeans.nvim mellow.nvim midnight.nvim night-owl.nvim nordic.nvim oxocarbon.nvim nvim-tundra zenbones.nvim
local specs = {
  {
    "Shatur/neovim-ayu",
    colors_names = {
      "ayu-dark",
      "ayu-mirage",
    },
    colors_names_light = {
      "ayu-light",
    },
  },
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
      rainbow_headings = true,
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
  {
    "comfysage/evergarden",
    colorscheme_style_key = "variant",
    colorscheme_styles = {
      "fall",
      "spring",
      "summer",
      "winter",
    },
  },
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
    colorscheme_style_key = "theme",
    colorscheme_styles = {
      "delta",
      "fluoromachine",
      "retrowave",
    },
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
  },
  {
    "ellisonleao/gruvbox.nvim",
    supports_light_background = true,
  },
  {
    "luisiacc/gruvbox-baby",
    colorscheme_style_suffix = "background_color",
    colorscheme_styles = {
      "dark",
      "medium",
      "soft",
      "soft_flat",
    },
  },
  {
    "sainnhe/gruvbox-material",
    colorscheme_style_suffix = "foreground",
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
    "wtfox/jellybeans.nvim",
    colors_names = {
      "jellybeans-default",
      "jellybeans-mono",
      "jellybeans-muted",
    },
    colors_names_light = {
      "jellybeans-light",
      "jellybeans-mono-light",
      "jellybeans-muted-light",
    },
    opts = {
      on_highlights = function(hl, palette)
        rainbow_delimiter_highlights({
          palette.raw_sienna,
          palette.brandy,
          palette.perano,
          palette.koromiko,
          palette.green_smoke,
          palette.biloba_flower,
          palette.calypso,
        }, hl)
      end,
    },
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
  },
  {
    "sho-87/kanagawa-paper.nvim",
    opts = {
      cache = true,
    },
    supports_light_background = true,
  },
  {
    "webhooked/kanso.nvim",
    colors_names = {
      "kanso-ink",
      "kanso-zen",
    },
    colors_names_light = {
      "kanso-pearl",
    },
  },
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
        "blink",
        "dap",
        "eyeliner",
        "flash",
        "gitsigns",
        "mini",
        "neogit",
        "noice",
        "nvim-notify",
        "nvim-web-devicons",
        "rainbow-delimiters",
        "telescope",
        "trouble",
        "which-key",
      },
    },
  },
  {
    "savq/melange-nvim",
    supports_light_background = true,
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
      "vaporwave",
    },
    colors_names_light = {
      "onelight",
    },
  },
  {
    "rmehri01/onenord.nvim",
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
    supports_light_background = true,
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
    colorscheme_style_suffix = "biome",
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
  { "vague2k/vague.nvim" },
  {
    "Mofiqul/vscode.nvim",
    opts = {
      color_overrides = {
        vscMediumBlue = "#18a2fe",
      },
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
}

return vim
  .iter(specs)
  :map(function(spec)
    local extra_spec = {}

    for _, key in ipairs({
      "colors_names",
      "colors_names_light",
      "colorscheme_style_key",
      "colorscheme_style_suffix",
      "colorscheme_styles",
      "highlights",
      "supports_light_background",
    }) do
      extra_spec[key] = spec[key]
      spec[key] = nil
    end

    if next(extra_spec) then
      if extra_spec.colorscheme_style_key then
        extra_spec.opts = spec.opts
      end

      util.extra_specs[util.normname(spec.name or spec[1])] = extra_spec
    end

    spec.lazy = true
    spec.priority = 1000

    return spec
  end)
  :totable()
