local util = require("util")

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

local add_init_colorscheme_autocmds = function(spec, get_highlights)
  spec.init = function()
    for _, colors_name in ipairs(spec.colors_names and spec.colors_names or { util.normname(spec[1]:gsub(".*/", "")) }) do
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
  return spec
end

return util.map({
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
        treesitter_context = true,
        ts_rainbow = true,
      },
    },
  },
  {
    "Mofiqul/dracula.nvim",
    colors_names = {
      "dracula-soft",
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
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_better_performance = 1
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 1
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    colors_names = {
      "github_dark",
      "github_dark_dimmed",
      "github_dark_high_contrast",
    },
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
    colors_names = {
      "kanagawa-drakon",
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
  add_init_colorscheme_autocmds({
    "marko-cerovac/material.nvim",
    colorscheme_styles = {
      "darker",
      "deep ocean",
      "oceanic",
      "palenight",
    },
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
  }, function()
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
  {
    "echasnovski/mini.base16",
    colors_names = {
      "minicyan",
      "minischeme",
    },
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
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
  },
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
  add_init_colorscheme_autocmds({
    "ray-x/starry.nvim",
    colors_names = {
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
    },
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
  {
    "folke/tokyonight.nvim",
    colors_names = {
      "tokyonight-moon",
      "tokyonight-night",
      "tokyonight-storm",
    },
  },
  add_init_colorscheme_autocmds({
    "sam4llis/nvim-tundra",
    opts = {
      plugins = {
        cmp = true,
        gitsigns = true,
        neogit = true,
        telescope = true,
      },
    },
  }, function()
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
  add_init_colorscheme_autocmds({
    "mcchrish/zenbones.nvim",
    colors_names = {
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
    },
  }, function(colors_name)
    local palette = require(colors_name .. ".palette")

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
}, function(colorscheme_spec)
  colorscheme_spec.lazy = true
  return colorscheme_spec
end)
