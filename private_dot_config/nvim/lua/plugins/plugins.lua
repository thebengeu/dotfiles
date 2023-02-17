return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  { "skywind3000/asyncrun.vim", cmd = "AsyncRun" },
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
    keys = { "h", "j", "k", "l", "<Left>", "<Down>", "<Up>", "<Right>" },
    opts = {
      grace_period = 2,
      ignore_filetypes = { "neo%-tree", "qf" },
    },
  },
  {
    "monaqa/dial.nvim",
    config = function()
      vim.list_extend(require("dial.config").augends.group.default, {
        require("dial.augend").constant.alias.bool,
      })
    end,
    keys = {
      {
        "<C-a>",
        "<Plug>(dial-increment)",
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
      },
      {
        "<C-a>",
        "<Plug>(dial-increment)",
        { mode = "v" },
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
        { mode = "v" },
      },
      {
        "g<C-a>",
        "g<Plug>(dial-increment)",
        { mode = "v" },
      },
      {
        "g<C-x>",
        "g<Plug>(dial-decrement)",
        { mode = "v" },
      },
    },
  },
  {
    "sainnhe/edge",
    lazy = true,
  },
  {
    "sainnhe/everforest",
    lazy = true,
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
  {
    "akinsho/git-conflict.nvim",
    config = true,
    event = "BufReadPost",
  },
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      require("which-key").register({
        ["<leader>gh"] = "which_key_ignore",
      })
    end,
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      current_line_blame_formatter_nc = "",
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
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
  {
    "sainnhe/gruvbox-material",
    lazy = true,
  },
  {
    "smjonas/inc-rename.nvim",
    config = true,
    lazy = true,
  },
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
      show_current_context_start = true,
      show_first_indent_level = false,
      use_treesitter = true,
    },
  },
  {
    "/hkupty/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          repl_open_cmd = require("iron.view").split.horizontal.botright(20, {
            number = false,
            relativenumber = false,
          }),
        },
        keymaps = {
          send_motion = "<space>m",
          visual_send = "<C-m>",
        },
      })
    end,
    keys = {
      { "<C-m>", mode = "v" },
      { "<C-m>", "gv<C-m>", remap = true },
      { "<space>r", "<Cmd>IronRepl<CR>", desc = "REPL" },
    },
  },
  {
    "GCBallesteros/jupytext.vim",
    config = function()
      vim.g.jupytext_fmt = "py"
      vim.g.jupytext_style = ":hydrogen"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
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
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ansible-lint",
        "black",
        "eslint_d",
        "fixjson",
        "isort",
        "js-debug-adapter",
        "prettierd",
        "shellharden",
        "yamlfmt",
        "yamllint",
      })
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
    "EdenEast/nightfox.nvim",
    lazy = true,
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
      presets = {
        command_palette = false,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = {
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.flake8.with({
          extra_args = { "--max-line-length", "88" },
        }),
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.isort.with({
          extra_args = { "--profile", "black" },
        }),
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = { "prisma" },
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.yamlfmt,
      }
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        should_preview_cb = function(bufnr, qwinid)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match("^fugitive://") and not vim.api.nvim_buf_is_loaded(bufnr) then
            if bqf_pv_timer and bqf_pv_timer:get_due_in() > 0 then
              bqf_pv_timer:stop()
              bqf_pv_timer = nil
            end
            bqf_pv_timer = vim.defer_fn(function()
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd(("do fugitive BufReadCmd %s"):format(bufname))
              end)
              require("bqf.preview.handler").open(qwinid, nil, true)
            end, 60)
          end
          return true
        end,
      },
    },
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
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "copilot" },
      }))
    end,
  },
  {
    "haringsrob/nvim_context_vt",
    event = "BufReadPost",
    opts = {
      disable_virtual_lines_ft = { "yaml" },
      prefix = "",
    },
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
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
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
              cwd = "${workspaceFolder}",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              request = "attach",
              type = "pwa-node",
            },
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
    dependencies = "mfussenegger/nvim-dap",
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
      keys[#keys + 1] = { "gd", false }
      keys[#keys + 1] = { "gI", false }
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = { "gt", false }
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
        ansiblels = {},
        bashls = {},
        prismals = {},
        pyright = {},
        tsserver = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
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
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "fish",
        "gitignore",
        "prisma",
      })
      opts.rainbow = {
        enable = true,
        extended_mode = true,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = true,
    event = "BufReadPost",
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
    init = function()
      require("which-key").register({
        [","] = "Previous text subject",
        ["."] = "Text subject smart",
        [";"] = "Text subject container outer",
        ["i;"] = "text subject container inner",
      }, { mode = "o" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true,
    event = "InsertEnter",
  },
  {
    "mrjones2014/nvim-ts-rainbow",
    event = "BufReadPost",
  },
  {
    "kevinhwang91/nvim-ufo",
    config = true,
    dependencies = "kevinhwang91/promise-async",
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
  {
    "vuki656/package-info.nvim",
    config = true,
    ft = "json",
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
        "<leader>cF",
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        desc = "Refactor",
        mode = { "n", "v" },
      },
    },
  },
  {
    "lewis6991/satellite.nvim",
    config = true,
    event = "BufReadPost",
  },
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
    dependencies = "kkharji/sqlite.lua",
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
    "sainnhe/sonokai",
    lazy = true,
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
    "abecodes/tabout.nvim",
    config = true,
    dependencies = "hrsh7th/nvim-cmp",
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
  {
    "blankname/vim-fish",
    ft = "fish",
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Gclog" },
  },
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
  {
    "tpope/vim-unimpaired",
    config = function()
      for _, key in ipairs({
        "<C-L>",
        "<C-Q>",
        "<C-T>",
        "<space>",
        "A",
        "a",
        "B",
        "C",
        "f",
        "L",
        "l",
        "n",
        "o",
        "P",
        "p",
        "T",
        "u",
        "x",
        "y",
      }) do
        require("which-key").register({
          ["[" .. key] = "which_key_ignore",
          ["]" .. key] = "which_key_ignore",
        })
      end
      require("which-key").register({
        ["[q"] = "Previous item in quickfix list",
        ["]q"] = "Next item in quickfix list",
        ["[Q"] = "First item in quickfix list",
        ["]Q"] = "Last item in quickfix list",
      })
    end,
    event = "VeryLazy",
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
  },
  {
    "wakatime/vim-wakatime",
    event = "BufReadPost",
  },
}
