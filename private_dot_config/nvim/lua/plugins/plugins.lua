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
  { "alker0/chezmoi.vim" },
  {
    "ja-ford/delaytrain.nvim",
    config = function()
      require("delaytrain").setup({
        grace_period = 2,
      })
    end,
    keys = { "h", "j", "k", "l", "<Left>", "<Down>", "<Up>", "<Right>" },
  },
  { "jinh0/eyeliner.nvim", event = "BufReadPost" },
  { "rmagatti/goto-preview", event = "BufReadPost", opts = { default_mappings = true } },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
      },
      show_current_context = true,
      show_first_indent_level = false,
      use_treesitter = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "mrjones2014/legendary.nvim",
    event = "BufReadPost",
    opts = {
      autocmds = {
        {
          { "BufEnter", "FocusGained" },
          'call system("tmux rename-window " . expand("%:p"))',
        },
        {
          "BufWritePost",
          "!chezmoi apply --source-path <afile>",
          opts = { pattern = "*/.local/share/chezmoi/*" },
        },
      },
    },
  },
  -- {
  --   "lvimuser/lsp-inlayhints.nvim",
  --   config = true,
  -- },
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
  -- {
  --   "mawkler/modicator.nvim",
  --   dependencies = "catppuccin",
  --   config = function()
  --     local C = require("catppuccin.palettes").get_palette()
  --     require("modicator").setup({
  --       highlights = {
  --         modes = {
  --           ["n"] = {
  --             foreground = C.blue,
  --           },
  --           ["i"] = {
  --             foreground = C.green,
  --           },
  --           ["v"] = {
  --             foreground = C.mauve,
  --           },
  --           ["V"] = {
  --             foreground = C.mauve,
  --           },
  --           ["�"] = {
  --             foreground = C.mauve,
  --           },
  --           ["s"] = {
  --             foreground = C.mauve,
  --           },
  --           ["S"] = {
  --             foreground = C.mauve,
  --           },
  --           ["R"] = {
  --             foreground = C.red,
  --           },
  --           ["c"] = {
  --             foreground = C.peach,
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "mvllow/modes.nvim",
    config = function()
      local C = require("catppuccin.palettes").get_palette()
      require("modes").setup({
        colors = {
          copy = C.blue,
          delete = C.red,
          insert = C.green,
          visual = C.mauve,
        },
      })
    end,
    event = "BufReadPost",
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup({
          method = "getPanelCompletions",
          formatters = {
            insert_text = require("copilot_cmp.format").remove_existing,
          },
        })
      end,
      dependencies = {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            panel = { enabled = false },
            suggestion = { enabled = false },
          })
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
      })
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          require("copilot_cmp.comparators").score,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
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
    end,
    init = function()
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
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
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
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
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
    "kevinhwang91/nvim-hlslens",
    keys = {
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "*",
        "*<Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "#",
        "#<Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "g*",
        "g*<Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "g#",
        "g#<Cmd>lua require('hlslens').start()<CR>",
      },
    },
    opts = {
      calm_down = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          on_attach = function(client, buffer)
            -- require("lsp-inlayhints").on_attach(client, buffer)
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function()
                local actions = require("typescript").actions
                actions.removeUnused({ sync = true })
                actions.addMissingImports({ sync = true })
                actions.organizeImports({ sync = true })
                vim.lsp.buf.format()
              end,
              pattern = "<buffer>",
            })
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },
  { "SmiteshP/nvim-navic", opts = {
    highlight = true,
  } },
  { "nvim-treesitter/nvim-treesitter-context", event = "VimEnter" },
  { "mrjones2014/nvim-ts-rainbow", event = "BufReadPost" },
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
    "RRethy/nvim-treesitter-textsubjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          prev_selection = ",",
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
      })
    end,
    event = "BufReadPost",
  },
  { "windwp/nvim-ts-autotag", config = true, event = "InsertEnter" },
  -- {
  --   "chrisgrieser/nvim-various-textobjs",
  --   config = function()
  --     require("various-textobjs").setup({ useDefaultKeymaps = true })
  --   end,
  --   event = "BufReadPost",
  -- },
  { "vuki656/package-info.nvim", config = true, ft = "json" },
  {
    "danth/pathfinder.vim",
    config = function()
      vim.g.pf_autorun_delay = 1
    end,
    event = "BufReadPost",
  },
  {
    "cbochs/portal.nvim",
    keys = {
      {
        "<leader>o",
        function()
          require("portal").jump_backward()
        end,
        desc = "Jump Backward",
      },
      {
        "<leader>i",
        function()
          require("portal").jump_forward()
        end,
        desc = "Jump Forward",
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
      require("telescope").load_extension("projects")
    end,
    event = "VeryLazy",
    keys = {
      {
        "<leader>sp",
        function()
          require("telescope").extensions.projects.projects()
        end,
        desc = "Projects",
      },
    },
  },
  { "lewis6991/satellite.nvim", config = true, event = "BufReadPost" },
  {
    "danielfalk/smart-open.nvim",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      { "<leader><space>", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
    },
  },
  {
    "gbprod/substitute.nvim",
    event = "BufReadPost",
    keys = {
      {
        "x",
        function()
          require("substitute").operator()
        end,
      },
      {
        "xx",
        function()
          require("substitute").line()
        end,
      },
      {
        "X",
        function()
          require("substitute").eol()
        end,
      },
      {
        "x",
        function()
          require("substitute").visual()
        end,
        mode = "x",
      },
    },
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
      { "<leader><space>", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    config = function()
      require("telescope").load_extension("undo")
    end,
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo" },
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
  { "axelvc/template-string.nvim", config = true, event = "InsertEnter" },
  {
    "aserowy/tmux.nvim",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    opts = {
      resize = {
        enable_default_keybindings = false,
      },
    },
  },
  { "mbbill/undotree", event = "BufReadPost" },
  { "blankname/vim-fish", ft = "fish" },
  { "tpope/vim-fugitive", event = "BufReadPost" },
  { "andymass/vim-matchup", event = "BufReadPost" },
  { "wakatime/vim-wakatime", event = "BufReadPost" },
}
