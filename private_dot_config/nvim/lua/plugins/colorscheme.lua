local g = vim.g

local colorschemes = {
  { "carbonfox" },
  { "catppuccin-frappe" },
  { "catppuccin-macchiato" },
  { "catppuccin-mocha" },
  { "duskfox" },
  { "edge", "aura" },
  { "edge", "default" },
  { "edge", "neon" },
  { "everforest" },
  { "gruvbox-material" },
  { "kanagawa" },
  { "material", "darker" },
  { "material", "deep ocean" },
  { "material", "oceanic" },
  { "material", "palenight" },
  { "nightfox" },
  { "nordfox" },
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
        cmp = true,
        dap = {
          enable_ui = true,
          enabled = true,
        },
        gitsigns = true,
        illuminate = true,
        indent_blankline = {
          enabled = true,
        },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
        },
        navic = {
          enabled = true,
        },
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        ts_rainbow = true,
        which_key = true,
      },
    },
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
    config = function()
      local default_colors = require("kanagawa.colors").setup()

      require("kanagawa").setup({
        overrides = {
          rainbowcol1 = { fg = default_colors.peachRed },
          rainbowcol2 = { fg = default_colors.carpYellow },
          rainbowcol3 = { fg = default_colors.crystalBlue },
          rainbowcol4 = { fg = default_colors.surimiOrange },
          rainbowcol5 = { fg = default_colors.springGreen },
          rainbowcol6 = { fg = default_colors.oniViolet },
          rainbowcol7 = { fg = default_colors.waveAqua2 },
        },
      })
    end,
    lazy = true,
  },
  {
    "LazyVim/LazyVim",
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
    config = function()
      local colors = require("material.colors")

      require("material").setup({
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
      })
    end,
    lazy = true,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
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
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      { "<leader><space>", false },
      {
        "<leader>fi",
        function()
          require("telescope.builtin").find_files({
            no_ignore = true,
          })
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
        "<leader>si",
        function()
          require("telescope.builtin").live_grep({
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--column",
              "--line-number",
              "--no-heading",
              "--no-ignore",
              "--smart-case",
              "--with-filename",
            },
          })
        end,
        desc = "Grep (ignored)",
      },
      {
        "<leader>sp",
        function()
          local root = require("lazy.core.config").options.root
          require("telescope.pickers")
            .new({
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
              finder = require("telescope.finders").new_oneshot_job({ "ls", root }),
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
            .new({
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
    },
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
    },
  },
}
