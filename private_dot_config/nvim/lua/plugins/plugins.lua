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
  {
    "jinh0/eyeliner.nvim",
    config = function()
      local C = require("catppuccin.palettes").get_palette()
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = C.red, bold = true, underline = true })
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = C.peach, bold = true, underline = true })
    end,
    event = "BufReadPost",
  },
  { "akinsho/git-conflict.nvim", config = true, event = "BufReadPost" },
  {
    "DNLHC/glance.nvim",
    config = true,
    keys = {
      { "gd", "<Cmd>Glance definitions<cr>", desc = "Goto Definition" },
      { "gI", "<Cmd>Glance implementations<cr>", desc = "Goto Implementation" },
      { "gr", "<Cmd>Glance references<cr>", desc = "References" },
      { "gt", "<Cmd>Glance type_definitions<cr>", desc = "Goto Type Definition" },
    },
  },
  { "smjonas/inc-rename.nvim", config = true, keys = { "<leader>cr" } },
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
    "echasnovski/mini.indentscope",
    init = function()
      vim.g.miniindentscope_disable = true
    end,
    opts = {
      options = {
        border = "top",
      },
    },
  },
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
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      return {
        sources = vim.list_extend(opts.sources, {
          nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.fish_indent,
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
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
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
  { "haringsrob/nvim_context_vt", event = "BufReadPost" },
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
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
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
            debugger_path = os.getenv("HOME") .. "/vscode-js-debug",
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
    event = "BufReadPost",
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
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", false, mode = "i" }
      keys[#keys + 1] = { "gd", false }
      keys[#keys + 1] = { "gI", false }
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = { "gt", false }
      keys[#keys + 1] =
        { "<C-l>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" }
    end,
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      servers = {
        tsserver = {
          on_attach = function()
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
        },
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    opts = { highlight = true },
  },
  {
    "mfussenegger/nvim-treehopper",
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
    end,
    event = "BufReadPost",
    init = function()
      require("which-key").register({
        m = "Nodes",
      }, { mode = { "o", "x" } })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "fish",
        "gitignore",
      },
      rainbow = {
        enable = true,
        extended_mode = true,
      },
    },
  },
  { "nvim-treesitter/nvim-treesitter-context", config = true, event = "BufReadPost" },
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
    init = function()
      require("which-key").register({
        [","] = "Previous text subject",
        ["."] = "Text subject smart",
        [";"] = "Text subject container outer",
        ["i;"] = "text subject container inner",
      }, { mode = "o" })
    end,
  },
  { "windwp/nvim-ts-autotag", config = true, event = "InsertEnter" },
  { "mrjones2014/nvim-ts-rainbow", event = "BufReadPost" },
  {
    "kevinhwang91/nvim-ufo",
    config = true,
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
    },
  },
  { "vuki656/package-info.nvim", config = true, ft = "json" },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
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
      require("project_nvim").setup({
        ignore_lsp = {
          "null-ls",
          "sumneko_lua",
        },
      })
    end,
    event = "BufEnter",
    keys = {
      {
        "<leader>p",
        function()
          require("telescope").extensions.projects.projects()
        end,
        desc = "Projects",
      },
    },
  },
  {
    "linty-org/readline.nvim",
    keys = {
      {
        "<C-a>",
        function()
          require("readline").dwim_beginning_of_line()
        end,
        mode = "!",
      },
      {
        "<C-e>",
        function()
          require("readline").end_of_line()
        end,
        mode = "!",
      },
      {
        "<C-k>",
        function()
          require("readline").kill_line()
        end,
        mode = "!",
      },
      {
        "<C-u>",
        function()
          require("readline").dwim_backward_kill_line()
        end,
        mode = "!",
      },
      {
        "<C-w>",
        function()
          require("readline").unix_word_rubout()
        end,
        mode = "!",
      },
      {
        "<M-BS>",
        function()
          require("readline").backward_kill_word()
        end,
        mode = "!",
      },
      {
        "<M-b>",
        function()
          require("readline").backward_word()
        end,
        mode = "!",
      },
      {
        "<M-d>",
        function()
          require("readline").kill_word()
        end,
        mode = "!",
      },
      {
        "<M-f>",
        function()
          require("readline").forward_word()
        end,
        mode = "!",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>cR",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        desc = "Refactors",
        mode = { "n", "v" },
      },
    },
  },
  { "lewis6991/satellite.nvim", config = true, event = "BufReadPost" },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPost",
    opts = {
      foldfunc = "builtin",
      setopt = true,
    },
  },
  {
    "danielfalk/smart-open.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader><space>",
        function()
          require("telescope").extensions.smart_open.smart_open()
        end,
        desc = "Smart Open",
      },
    },
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sR",
        function()
          require("ssr").open()
        end,
        desc = "Structural Replace",
        mode = { "n", "x" },
      },
    },
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({
        on_substitute = require("yanky.integration").substitute(),
      })
    end,
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
    "simrat39/symbols-outline.nvim",
    config = true,
    keys = {
      { "<leader>cs", "<Cmd>SymbolsOutline<CR>", desc = "Symbols Outline" },
    },
  },
  {
    "abecodes/tabout.nvim",
    config = true,
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
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
    init = function()
      local C = require("catppuccin.palettes").get_palette()
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = C.crust, fg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = C.crust, fg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = C.mantle, fg = C.crust })
      vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = C.mantle })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = C.mantle })
    end,
    keys = {
      { "<leader><space>", false },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin Files",
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
  {
    "nvim-telescope/telescope-dap.nvim",
    keys = {
      {
        "<leader>dl",
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        desc = "List Breakpoints",
      },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      {
        "<leader>su",
        function()
          require("telescope").extensions.undo.undo()
        end,
        desc = "Undo",
      },
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
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<Cmd>TSJToggle<CR>" },
    },
    opts = { use_default_keymaps = false },
  },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "blankname/vim-fish", ft = "fish" },
  { "tpope/vim-fugitive", cmd = "G" },
  {
    "andymass/vim-matchup",
    init = function()
      require("which-key").register({
        ["a%"] = "any block",
        ["i%"] = "inner any block",
      }, { mode = "o" })
    end,
    event = "BufReadPost",
  },
  { "simnalamburt/vim-mundo", cmd = "MundoToggle" },
  { "mg979/vim-visual-multi", event = "BufReadPost" },
  { "wakatime/vim-wakatime", event = "BufReadPost" },
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
      { "<c-n>", "<Plug>(YankyCycleForward)" },
      { "<c-p>", "<Plug>(YankyCycleBackward)" },
      {
        "<leader>sy",
        function()
          require("telescope").extensions.yank_history.yank_history()
        end,
        desc = "Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },
      { "=p", "<Plug>(YankyPutAfterFilter)" },
      { "=P", "<Plug>(YankyPutBeforeFilter)" },
    },
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
}
