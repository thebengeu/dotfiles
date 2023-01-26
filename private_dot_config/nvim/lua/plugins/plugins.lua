return {
  {
    "catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        integrations = {
          cmp = true,
          dap = {
            enable_ui = true,
            enabled = true,
          },
          gitsigns = true,
          indent_blankline = {
            colored_indent_levels = true,
            enabled = true,
          },
          leap = true,
          mason = true,
          native_lsp = {
            enabled = true,
          },
          neogit = true,
          neotree = true,
          notify = true,
          telescope = true,
          treesitter = true,
          ts_rainbow = true,
          which_key = true,
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").on_attach(function(_, buffer)
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "typescript.nvim",
            pattern = "<buffer>",
            callback = function()
              local actions = require("typescript").actions
              actions.removeUnused({ sync = true })
              actions.addMissingImports({ sync = true })
              actions.organizeImports({ sync = true })
              vim.lsp.buf.format()
            end,
          })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tsserver = {},
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },
  {
    "TimUntersberger/neogit",
    dependencies = {
      "sindrets/diffview.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true,
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "zbirenbaum/copilot-cmp" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.experimental = { ghost_text = true }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "copilot" } }))
    end,
  },
  { "mrjones2014/nvim-ts-rainbow" },
  {
    "danielfalk/smart-open.nvim",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = { "kkharji/sqlite.lua" },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><space>", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
    },
  },
  { "blankname/vim-fish" },
  { "tpope/vim-fugitive" },
  { "fladson/vim-kitty" },
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-unimpaired" },
  { "wakatime/vim-wakatime" },
}
