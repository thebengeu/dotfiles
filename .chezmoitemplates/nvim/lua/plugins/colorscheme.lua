return {
  {
    "ribru17/bamboo.nvim",
    lazy = true,
  },
  {
    "uloco/bluloco.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = true,
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
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
  },
  {
    "sainnhe/edge",
    config = function()
      vim.g.edge_better_performance = 1
      vim.g.edge_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_better_performance = 1
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "projekt0n/github-nvim-theme",
    opts = function()
      return {
        groups = {
          all = {
            RainbowDelimiterRed = { fg = "palette.red" },
            RainbowDelimiterYellow = { fg = "palette.yellow" },
            RainbowDelimiterBlue = { fg = "palette.blue" },
            RainbowDelimiterOrange = { fg = "palette.pink" },
            RainbowDelimiterGreen = { fg = "palette.green" },
            RainbowDelimiterViolet = { fg = "palette.magenta" },
            RainbowDelimiterCyan = { fg = "palette.cyan" },
          },
        },
      }
    end,
    lazy = true,
    main = "github-theme",
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
  },
  {
    "luisiacc/gruvbox-baby",
    lazy = true,
  },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_foreground = "original"
    end,
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      overrides = function(colors)
        return {
          RainbowDelimiterRed = { fg = colors.palette.peachRed },
          RainbowDelimiterYellow = { fg = colors.palette.carpYellow },
          RainbowDelimiterBlue = { fg = colors.palette.crystalBlue },
          RainbowDelimiterOrange = { fg = colors.palette.surimiOrange },
          RainbowDelimiterGreen = { fg = colors.palette.springGreen },
          RainbowDelimiterViolet = { fg = colors.palette.oniViolet },
          RainbowDelimiterCyan = { fg = colors.palette.waveAqua2 },
        }
      end,
    },
    lazy = true,
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
    lazy = true,
  },
  {
    "echasnovski/mini.base16",
    lazy = true,
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = true,
  },
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = true,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    "AlexvZyl/nordic.nvim",
    opts = function()
      local colors = require("nordic.colors")

      return {
        override = {
          RainbowDelimiterRed = { fg = colors.red.base },
          RainbowDelimiterYellow = { fg = colors.yellow.base },
          RainbowDelimiterBlue = { fg = colors.blue0 },
          RainbowDelimiterOrange = { fg = colors.orange.base },
          RainbowDelimiterGreen = { fg = colors.green.base },
          RainbowDelimiterViolet = { fg = colors.magenta.base },
          RainbowDelimiterCyan = { fg = colors.cyan.base },
        },
      }
    end,
    lazy = true,
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
    lazy = true,
    opts = {
      plugins = {
        cmp = true,
        gitsigns = true,
        neogit = true,
        telescope = true,
      },
    },
  },
  {
    "cpea2506/one_monokai.nvim",
    lazy = true,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
  },
  {
    "rmehri01/onenord.nvim",
    lazy = true,
  },
  {
    "rose-pine/neovim",
    lazy = true,
    name = "rose-pine",
    opts = {
      highlight_groups = {
        RainbowDelimiterRed = { fg = "love" },
        RainbowDelimiterYellow = { fg = "gold" },
        RainbowDelimiterBlue = { fg = "pine" },
        RainbowDelimiterOrange = { fg = "rose" },
        RainbowDelimiterGreen = { fg = "foam" },
        RainbowDelimiterViolet = { fg = "iris" },
        RainbowDelimiterCyan = { fg = "highlight_high" },
      },
    },
  },
  {
    "olivercederborg/poimandres.nvim",
    lazy = true,
  },
  {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "ray-x/starry.nvim",
    lazy = true,
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
        group_overrides = {
          RainbowDelimiterRed = { fg = colors.vscRed },
          RainbowDelimiterYellow = { fg = colors.vscYellow },
          RainbowDelimiterBlue = { fg = colors.vscBlue },
          RainbowDelimiterOrange = { fg = colors.vscOrange },
          RainbowDelimiterGreen = { fg = colors.vscGreen },
          RainbowDelimiterViolet = { fg = colors.vscViolet },
          RainbowDelimiterCyan = { fg = colors.vscBlueGreen },
        },
      }
    end,
    lazy = true,
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
    lazy = true,
  },
}
