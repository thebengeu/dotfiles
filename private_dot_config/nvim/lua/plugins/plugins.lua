return {
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
      })
    end,
  },
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
          colored_indent_levels = true,
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
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = { enabled = false },
      })
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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "mrjones2014/legendary.nvim",
    opts = {
      autocmds = {
        {
          { "BufEnter", "FocusGained" },
          'call system("tmux rename-window " . expand("%:p"))',
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "catppuccin",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      return {
        ensure_installed = vim.list_extend(opts.ensure_installed, {
          "eslint_d",
          "js-debug-adapter",
          "prettierd",
        }),
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      return {
        sources = vim.list_extend(opts.sources, {
          nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.formatting.prettierd.with({
            extra_filetypes = { "prisma" },
          }),
        }),
      }
    end,
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
    "hrsh7th/nvim-cmp",
    dependencies = { "zbirenbaum/copilot-cmp" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.experimental = { ghost_text = true }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "copilot" } }))
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap")
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      require("which-key").register({
        ["<leader>d"] = { name = "+debug" },
      })
    end,
    keys = {
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dt",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>du",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dU",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    config = function()
      require("dap-vscode-js").setup({
        adapters = { "pwa-node" },
        -- debugger_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path(),
        debugger_path = os.getenv("HOME") .. "/vscode-js-debug",
        -- log_file_level = vim.log.levels.DEBUG,
        -- log_file_path = os.getenv("HOME") .. "/.cache/dap_vscode_js.log",
      })
      require("dap").configurations["typescript"] = {
        {
          console = "integratedTerminal",
          cwd = "${workspaceFolder}",
          name = "ts-node/esm/transpile-only",
          program = "${file}",
          request = "launch",
          runtimeArgs = { "--loader", "ts-node/esm/transpile-only" },
          type = "pwa-node",
        },
      }
    end,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  { "SmiteshP/nvim-navic", opts = {
    highlight = true,
  } },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "mrjones2014/nvim-ts-rainbow" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      rainbow = {
        enable = true,
        extended_mode = true,
      },
    },
  },
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
  {
    "nvim-telescope/telescope-dap.nvim",
    config = function()
      require("telescope").load_extension("dap")
    end,
    keys = {
      { "<leader>dl", "<cmd>Telescope dap list_breakpoints<cr>", desc = "List Breakpoints" },
    },
  },
  { "blankname/vim-fish" },
  { "tpope/vim-fugitive" },
  { "christoomey/vim-tmux-navigator" },
  { "wakatime/vim-wakatime" },
}
