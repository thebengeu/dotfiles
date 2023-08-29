local Util = require("lazyvim.util")

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

local current_colorscheme_and_style

local set_colorscheme_style = function(colorscheme_and_style)
  current_colorscheme_and_style = colorscheme_and_style
  if colorscheme_and_style[2] then
    vim.g[colorscheme_and_style[1] .. "_style"] = colorscheme_and_style[2]
  end
end

math.randomseed(os.time())
set_colorscheme_style(colorschemes[math.random(#colorschemes)])

vim.keymap.set("n", "<leader>uR", function()
  set_colorscheme_style(colorschemes[math.random(#colorschemes)])
  vim.cmd.colorscheme(current_colorscheme_and_style[1])
end, { desc = "Randomise Colorscheme" })

return {
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
          return float_term(cmd or { "fish" }, opts)
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
  },
  {
    "rose-pine/neovim",
    lazy = true,
    name = "rose-pine",
    opts = {
      highlight_groups = {
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
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
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
      vim.list_extend(keys, {
        { "<leader>/", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
        { "<leader><space>", false },
        { "<leader>fF", Util.telescope("find_files"), desc = "Find Files (root dir)" },
        { "<leader>ff", Util.telescope("find_files", { cwd = false }), desc = "Find Files (cwd)" },
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
        { "<leader>gC", "<Cmd>Telescope git_commits<CR>", desc = "commits" },
        {
          "<leader>si",
          function()
            Util.telescope("live_grep", {
              vimgrep_arguments = vim.list_extend(
                vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
                { "--no-ignore" }
              ),
            })()
          end,
          desc = "Grep (root dir ignored)",
        },
        {
          "<leader>sI",
          function()
            Util.telescope("live_grep", {
              cwd = false,
              vimgrep_arguments = vim.list_extend(
                vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
                { "--no-ignore" }
              ),
            })()
          end,
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
                      cwd = root .. "/" .. selection[1],
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
          "<leader>sv",
          function()
            require("telescope.builtin").live_grep({
              cwd = require("lazy.core.config").options.root .. "/LazyVim",
            })
          end,
          desc = "Grep LazyVim",
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
                    set_colorscheme_style(selection.value)
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
    opts = function(_, opts)
      opts.defaults = vim.tbl_extend("force", opts.defaults, {
        layout_config = {
          flex = {
            flip_columns = 120,
          },
        },
        layout_strategy = "flex",
        vimgrep_arguments = vim.list_extend(
          vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
          { "--hidden" }
        ),
        winblend = 5,
      })
      opts.extensions = {
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },
      }
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    opts = function()
      local colors = require("vscode.colors").get_colors()

      return {
        group_overrides = {
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
