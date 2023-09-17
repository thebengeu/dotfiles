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
    opts = function()
      return {
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
      }
    end,
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
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local colors = require("material.colors")

          vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.main.red })
          vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.main.yellow })
          vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.main.blue })
          vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.main.orange })
          vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = colors.main.green })
          vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.main.purple })
          vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.main.cyan })
        end,
        pattern = "material",
      })
    end,
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
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local colors = require("nvim-tundra.palette.arctic")

          if not colors then
            error()
          end

          vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.red._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.sand._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.sky._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.orange._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = colors.green._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.indigo._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.opal._500 })
          vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.cyan })
        end,
        pattern = "tundra",
      })
    end,
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
    init = function()
      for _, colorscheme_name in ipairs({
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
      }) do
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            local colors = require("starry.colors").color_table()

            vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.red })
            vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.yellow })
            vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.blue })
            vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.orange })
            vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = colors.green })
            vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.purple })
            vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.cyan })
          end,
          pattern = colorscheme_name,
        })
      end
    end,
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
    init = function()
      for _, colorscheme_name in ipairs({
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
      }) do
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            local palette = require(colorscheme_name .. ".palette")

            vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = palette.dark.rose.hex })
            vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = palette.dark.wood.hex })
            vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = palette.dark.water.hex })
            vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = palette.dark.fg.hex })
            vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = palette.dark.leaf.hex })
            vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = palette.dark.blossom.hex })
            vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = palette.dark.sky.hex })
          end,
          pattern = colorscheme_name,
        })
      end
    end,
  },
}, function(colorscheme_spec)
  colorscheme_spec.lazy = true
  return colorscheme_spec
end)
