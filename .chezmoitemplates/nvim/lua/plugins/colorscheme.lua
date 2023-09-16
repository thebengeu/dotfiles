local colorschemes = {
  { "bamboo" },
  { "bluloco" },
  { "carbonfox" },
  { "catppuccin-frappe" },
  { "catppuccin-macchiato" },
  { "catppuccin-mocha" },
  { "dracula" },
  { "dracula-soft" },
  { "duskfox" },
  { "edge", "aura" },
  { "edge", "default" },
  { "edge", "neon" },
  { "everforest" },
  { "github_dark" },
  { "github_dark_dimmed" },
  { "github_dark_high_contrast" },
  { "gruvbox" },
  { "gruvbox-material" },
  { "gruvbox-baby" },
  { "kanagawa-dragon" },
  { "kanagawa-wave" },
  { "material", "darker" },
  { "material", "deep ocean" },
  { "material", "oceanic" },
  { "material", "palenight" },
  { "nightfox" },
  { "nordfox" },
  { "nordic" },
  { "one_monokai" },
  { "onedark" },
  { "onedark_dark" },
  { "onedark_vivid" },
  { "onenord" },
  { "poimandres" },
  { "rose-pine" },
  { "sonokai", "andromeda" },
  { "sonokai", "atlantis" },
  { "sonokai", "default" },
  { "sonokai", "espresso" },
  { "sonokai", "maia" },
  { "sonokai", "shusia" },
  { "terafox" },
  { "tokyonight-moon" },
  { "tokyonight-night" },
  { "tokyonight-storm" },
  { "tundra" },
  { "vscode" },
}

local colorscheme_index
local colorscheme

local set_colorscheme_style = function(index)
  colorscheme_index = index
  colorscheme = colorschemes[index]
  if colorscheme[2] then
    vim.g[colorscheme[1] .. "_style"] = colorscheme[2]
  end
end

math.randomseed(os.time())
set_colorscheme_style(math.random(#colorschemes))

vim.keymap.set("n", "<leader>uR", function()
  set_colorscheme_style(math.random(#colorschemes))
  vim.cmd.colorscheme(colorscheme[1])
end, { desc = "Randomise Colorscheme" })
vim.keymap.set("n", "[S", function()
  set_colorscheme_style(colorscheme_index == 1 and #colorschemes or colorscheme_index - 1)
  vim.cmd.colorscheme(colorscheme[1])
end, { desc = "Colorscheme backward" })
vim.keymap.set("n", "]S", function()
  set_colorscheme_style(colorscheme_index == #colorschemes and 1 or colorscheme_index + 1)
  vim.cmd.colorscheme(colorscheme[1])
end, { desc = "Colorscheme backward" })

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
    opts = function()
      local colors = require("gruvbox.palette").get_base_colors(vim.o.background, "")

      return {
        overrides = {
          RainbowDelimiterRed = { fg = colors.red },
          RainbowDelimiterYellow = { fg = colors.yellow },
          RainbowDelimiterBlue = { fg = colors.blue },
          RainbowDelimiterOrange = { fg = colors.orange },
          RainbowDelimiterGreen = { fg = colors.green },
          RainbowDelimiterViolet = { fg = colors.purple },
          RainbowDelimiterCyan = { fg = colors.cyan },
        },
      }
    end,
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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme[1],
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            return table.concat(colorscheme, "-")
          end,
        },
      },
    },
  },
  {
    "marko-cerovac/material.nvim",
    opts = function()
      local colors = require("material.colors")

      return {
        custom_highlights = {
          RainbowDelimiterRed = { fg = colors.main.red },
          RainbowDelimiterYellow = { fg = colors.main.yellow },
          RainbowDelimiterBlue = { fg = colors.main.blue },
          RainbowDelimiterOrange = { fg = colors.main.orange },
          RainbowDelimiterGreen = { fg = colors.main.green },
          RainbowDelimiterViolet = { fg = colors.main.purple },
          RainbowDelimiterCyan = { fg = colors.main.cyan },
        },
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
      }
    end,
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
      require("lazyvim.util").on_load("nvim-tundra", function()
        local colors = require("nvim-tundra.palette.arctic")
        local rainbowcols = {
          colors.red._500,
          colors.sand._500,
          colors.sky._500,
          colors.orange._500,
          colors.green._500,
          colors.indigo._500,
          colors.opal._500,
        }

        for i = 1, 7 do
          vim.api.nvim_set_hl(0, "rainbowcol" .. i, { fg = rainbowcols[i] })
        end
      end)
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
    opts = {
      themes = function(colors)
        return {
          RainbowDelimiterRed = { fg = colors.dark_red },
          RainbowDelimiterYellow = { fg = colors.orange },
          RainbowDelimiterBlue = { fg = colors.yellow },
          RainbowDelimiterOrange = { fg = colors.green },
          RainbowDelimiterGreen = { fg = colors.aqua },
          RainbowDelimiterViolet = { fg = colors.purple },
          RainbowDelimiterCyan = { fg = colors.cyan },
        }
      end,
    },
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
    "nvim-telescope/telescope.nvim",
    keys = function(_, keys)
      vim.list_extend(keys, {
        {
          "<leader>uC",
          function()
            require("telescope.pickers")
              .new({}, {
                attach_mappings = function(prompt_bufnr)
                  local actions = require("telescope.actions")
                  actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    set_colorscheme_style(selection.index)
                    vim.cmd.colorscheme(colorscheme[1])
                  end)
                  return true
                end,
                finder = require("telescope.finders").new_table({
                  results = colorschemes,
                  entry_maker = function(entry)
                    local colorscheme_and_style = table.concat(entry, "-")

                    return {
                      display = colorscheme_and_style,
                      ordinal = colorscheme_and_style,
                      value = entry,
                    }
                  end,
                }),
                sorter = require("telescope.config").values.generic_sorter(),
              })
              :find()
          end,
          desc = "Colorscheme",
        },
      })
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
}
