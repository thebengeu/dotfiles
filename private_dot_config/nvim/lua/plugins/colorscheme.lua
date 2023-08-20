local Util = require("lazyvim.util")
local g = vim.g

local colorschemes = {
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
  { "gruvbox-material" },
  { "kanagawa-dragon" },
  { "kanagawa-wave" },
  { "material", "darker" },
  { "material", "deep ocean" },
  { "material", "oceanic" },
  { "material", "palenight" },
  { "nightfox" },
  { "nordfox" },
  { "one_monokai" },
  { "onedark" },
  { "onedark_dark" },
  { "onedark_vivid" },
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
  { "vscode" },
}

local function set_colorscheme_style(colorscheme_and_style)
  if colorscheme_and_style[2] then
    g[colorscheme_and_style[1] .. "_style"] = colorscheme_and_style[2]
  end
end

math.randomseed(os.time())
local current_colorscheme_and_style = colorschemes[math.random(#colorschemes)]
set_colorscheme_style(current_colorscheme_and_style)

return {
  {
    "catppuccin",
    opts = {
      integrations = {
        dap = {
          enable_ui = true,
          enabled = true,
        },
        leap = true,
        treesitter_context = true,
        ts_rainbow = true,
      },
    },
  },
  {
    "Mofiqul/dracula.nvim",
    opts = function()
      local colors = require("dracula").colors()

      return {
        overrides = {
          IndentBlanklineIndent1 = { fg = colors.red },
          IndentBlanklineIndent2 = { fg = colors.green },
          IndentBlanklineIndent3 = { fg = colors.yellow },
          IndentBlanklineIndent4 = { fg = colors.purple },
          IndentBlanklineIndent5 = { fg = colors.pink },
          IndentBlanklineIndent6 = { fg = colors.cyan },
        },
      }
    end,
    lazy = true,
  },
  {
    "sainnhe/edge",
    config = function()
      g.edge_better_performance = 1
      g.edge_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "sainnhe/everforest",
    config = function()
      g.everforest_better_performance = 1
      g.everforest_background = "hard"
      g.everforest_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "projekt0n/github-nvim-theme",
    opts = function()
      return {
        groups = {
          all = {
            rainbowcol1 = { fg = "palette.red" },
            rainbowcol2 = { fg = "palette.yellow" },
            rainbowcol3 = { fg = "palette.blue" },
            rainbowcol4 = { fg = "palette.pink" },
            rainbowcol5 = { fg = "palette.green" },
            rainbowcol6 = { fg = "palette.magenta" },
            rainbowcol7 = { fg = "palette.cyan" },
          },
        },
      }
    end,
    lazy = true,
    main = "github-theme",
  },
  {
    "sainnhe/gruvbox-material",
    config = function()
      g.gruvbox_material_background = "hard"
      g.gruvbox_material_better_performance = 1
      g.gruvbox_material_enable_italic = 1
      g.gruvbox_material_foreground = "original"
    end,
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      overrides = function(colors)
        return {
          rainbowcol1 = { fg = colors.palette.peachRed },
          rainbowcol2 = { fg = colors.palette.carpYellow },
          rainbowcol3 = { fg = colors.palette.crystalBlue },
          rainbowcol4 = { fg = colors.palette.surimiOrange },
          rainbowcol5 = { fg = colors.palette.springGreen },
          rainbowcol6 = { fg = colors.palette.oniViolet },
          rainbowcol7 = { fg = colors.palette.waveAqua2 },
        }
      end,
    },
    lazy = true,
  },
  {
    "LazyVim/LazyVim",
    init = function()
      if jit.os:find("Windows") then
        local float_term = Util.float_term

        ---@diagnostic disable-next-line: duplicate-set-field
        Util.float_term = function(cmd, opts)
          return float_term(cmd or { "nu" }, opts)
        end
      end
    end,
    opts = {
      colorscheme = current_colorscheme_and_style[1],
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            return table.concat(current_colorscheme_and_style, "-")
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
          rainbowcol1 = { fg = colors.main.red },
          rainbowcol2 = { fg = colors.main.yellow },
          rainbowcol3 = { fg = colors.main.blue },
          rainbowcol4 = { fg = colors.main.orange },
          rainbowcol5 = { fg = colors.main.green },
          rainbowcol6 = { fg = colors.main.purple },
          rainbowcol7 = { fg = colors.main.cyan },
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
    "cpea2506/one_monokai.nvim",
    lazy = true,
    opts = {
      themes = function(colors)
        return {
          rainbowcol1 = { fg = colors.dark_red },
          rainbowcol2 = { fg = colors.orange },
          rainbowcol3 = { fg = colors.yellow },
          rainbowcol4 = { fg = colors.green },
          rainbowcol5 = { fg = colors.aqua },
          rainbowcol6 = { fg = colors.purple },
          rainbowcol7 = { fg = colors.cyan },
        }
      end,
    },
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    opts = {
      highlights = {
        IndentBlanklineIndent1 = { fg = "${red}" },
        IndentBlanklineIndent2 = { fg = "${yellow}" },
        IndentBlanklineIndent3 = { fg = "${orange}" },
        IndentBlanklineIndent4 = { fg = "${green}" },
        IndentBlanklineIndent5 = { fg = "${blue}" },
        IndentBlanklineIndent6 = { fg = "${cyan}" },
      },
    },
  },
  {
    "rose-pine/neovim",
    lazy = true,
    name = "rose-pine",
    opts = {
      highlight_groups = {
        IndentBlanklineIndent1 = { fg = "love" },
        IndentBlanklineIndent2 = { fg = "gold" },
        IndentBlanklineIndent3 = { fg = "pine" },
        IndentBlanklineIndent4 = { fg = "rose" },
        IndentBlanklineIndent5 = { fg = "foam" },
        IndentBlanklineIndent6 = { fg = "iris" },
        rainbowcol1 = { fg = "love" },
        rainbowcol2 = { fg = "gold" },
        rainbowcol3 = { fg = "pine" },
        rainbowcol4 = { fg = "rose" },
        rainbowcol5 = { fg = "foam" },
        rainbowcol6 = { fg = "iris" },
        rainbowcol7 = { fg = "highlight_high" },
      },
    },
  },
  {
    "sainnhe/sonokai",
    config = function()
      g.sonokai_better_performance = 1
      g.sonokai_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzy-native.nvim",
      config = function()
        require("telescope").load_extension("fzy_native")
      end,
    },
    keys = function(_, keys)
      local vimgrep_arguments = {
        "rg",
        "--color=never",
        "--column",
        "--follow",
        "--hidden",
        "--line-number",
        "--no-heading",
        "--no-ignore",
        "--smart-case",
        "--with-filename",
      }

      local no_ignore_vimgrep_arguments = {}
      vim.list_extend(no_ignore_vimgrep_arguments, vimgrep_arguments)
      vim.list_extend(no_ignore_vimgrep_arguments, { "--no-ignore" })

      vim.list_extend(keys, {
        {
          "<leader>/",
          Util.telescope("live_grep", {
            cwd = false,
            vimgrep_arguments = vimgrep_arguments,
          }),
          desc = "Grep (cwd)",
        },
        { "<leader><space>", false },
        { "<leader>fF", Util.telescope("files"), desc = "Find Files (root dir)" },
        { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
        {
          "<leader>fi",
          function()
            require("telescope.builtin").find_files({ no_ignore = true })
          end,
          desc = "Find Files (ignored)",
        },
        {
          "<leader>fp",
          function()
            require("telescope.builtin").find_files({
              cwd = require("lazy.core.config").options.root,
            })
          end,
          desc = "Find Plugin Files",
        },
        {
          "<leader>sg",
          Util.telescope("live_grep", {
            vimgrep_arguments = vimgrep_arguments,
          }),
          desc = "Grep (root dir)",
        },
        {
          "<leader>sG",
          Util.telescope("live_grep", {
            cwd = false,
            vimgrep_arguments = vimgrep_arguments,
          }),
          desc = "Grep (cwd)",
        },
        {
          "<leader>si",
          Util.telescope("live_grep", {
            vimgrep_arguments = no_ignore_vimgrep_arguments,
          }),
          desc = "Grep (root dir ignored)",
        },
        {
          "<leader>sI",
          Util.telescope("live_grep", {
            cwd = false,
            vimgrep_arguments = no_ignore_vimgrep_arguments,
          }),
          desc = "Grep (cwd ignored)",
        },
        {
          "<leader>sp",
          function()
            local root = require("lazy.core.config").options.root
            require("telescope.pickers")
              .new({}, {
                attach_mappings = function(prompt_bufnr)
                  local actions = require("telescope.actions")
                  actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    require("telescope.builtin").live_grep({
                      search_dirs = { root .. "/" .. selection[1] },
                    })
                  end)
                  return true
                end,
                finder = require("telescope.finders").new_table({ results = vim.fn.readdir(root) }),
                sorter = require("telescope.config").values.file_sorter(),
              })
              :find()
          end,
          desc = "Grep Plugin Files",
        },
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
                    current_colorscheme_and_style = selection.value
                    set_colorscheme_style(current_colorscheme_and_style)
                    vim.cmd.colorscheme(current_colorscheme_and_style[1])
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
    opts = {
      defaults = {
        layout_config = {
          flex = {
            flip_columns = 120,
          },
        },
        layout_strategy = "flex",
        winblend = 5,
      },
      extensions = {
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },
      },
    },
  },
  {
    "Mofiqul/vscode.nvim",
    opts = function()
      local colors = require("vscode.colors").get_colors()

      return {
        group_overrides = {
          IndentBlanklineIndent1 = { fg = colors.vscRed },
          IndentBlanklineIndent2 = { fg = colors.vscYellow },
          IndentBlanklineIndent3 = { fg = colors.vscBlue },
          IndentBlanklineIndent4 = { fg = colors.vscOrange },
          IndentBlanklineIndent5 = { fg = colors.vscGreen },
          IndentBlanklineIndent6 = { fg = colors.vscViolet },
          rainbowcol1 = { fg = colors.vscRed },
          rainbowcol2 = { fg = colors.vscYellow },
          rainbowcol3 = { fg = colors.vscBlue },
          rainbowcol4 = { fg = colors.vscOrange },
          rainbowcol5 = { fg = colors.vscGreen },
          rainbowcol6 = { fg = colors.vscViolet },
          rainbowcol7 = { fg = colors.vscBlueGreen },
        },
      }
    end,
    lazy = true,
  },
}
