local colorschemes = {
  { "carbonfox" },
  { "catppuccin", "frappe" },
  { "catppuccin", "macchiato" },
  { "catppuccin", "mocha" },
  { "duskfox" },
  { "edge", "aura" },
  { "edge", "default" },
  { "edge", "neon" },
  { "everforest" },
  { "gruvbox-material" },
  { "kanagawa" },
  { "nightfox" },
  { "nordfox" },
  { "sonokai", "andromeda" },
  { "sonokai", "atlantis" },
  { "sonokai", "default" },
  { "sonokai", "espresso" },
  { "sonokai", "maia" },
  { "sonokai", "shusia" },
  { "terafox" },
  { "tokyonight", "moon" },
  { "tokyonight", "night" },
  { "tokyonight", "storm" },
}

math.randomseed(os.time())
local colorscheme = colorschemes[math.random(#colorschemes)]

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  { "rmagatti/auto-session" },
  {
    "catppuccin",
    opts = {
      flavor = colorscheme[2],
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
  { "alker0/chezmoi.vim" },
  { "github/copilot.vim" },
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
      local augend = require("dial.augend")

      vim.list_extend(require("dial.config").augends.group.default, {
        augend.constant.alias.bool,
        augend.constant.new({ elements = { "True", "False" } }),
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
    config = function()
      vim.g.edge_enable_italic = 1
      vim.g.edge_style = colorscheme[2]
    end,
    lazy = true,
  },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup()

      local add_bold_and_underline = function(name)
        vim.api.nvim_set_hl(0, name, {
          bold = true,
          fg = vim.api.nvim_get_hl_by_name(name, true).foreground,
          underline = true,
        })
      end

      local update_eyeliner_hl = function()
        add_bold_and_underline("EyelinerPrimary")
        add_bold_and_underline("EyelinerSecondary")
      end

      update_eyeliner_hl()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = update_eyeliner_hl,
      })
    end,
    event = "BufReadPre",
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
    keys = {
      { "gd", "<Cmd>Glance definitions<cr>", desc = "Goto Definition" },
      { "gI", "<Cmd>Glance implementations<cr>", desc = "Goto Implementation" },
      { "gr", "<Cmd>Glance references<cr>", desc = "References" },
      { "gt", "<Cmd>Glance type_definitions<cr>", desc = "Goto Type Definition" },
    },
    opts = {
      hooks = {
        before_open = function(results, open, jump)
          if #results == 1 then
            jump()
          else
            open() -- argument is optional
          end
        end,
      },
    },
  },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_enable_italic = 1
    end,
    lazy = true,
  },
  {
    "smjonas/inc-rename.nvim",
    config = true,
    lazy = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      local link_hl = function()
        for i = 1, 7 do
          vim.api.nvim_set_hl(0, "IndentBlanklineIndent" .. i, { link = "rainbowcol" .. i })
        end
      end

      link_hl()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = link_hl,
      })
    end,
    opts = {
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
        "IndentBlanklineIndent7",
      },
      show_current_context = true,
      use_treesitter = true,
    },
  },
  {
    "/hkupty/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          repl_definition = {
            python = require("iron.fts.python").ipython,
          },
          repl_open_cmd = require("iron.view").split.horizontal.botright(20, {
            number = false,
            relativenumber = false,
          }),
        },
        keymaps = {
          send_motion = "<space>z",
          visual_send = "<C-z>",
        },
      })
    end,
    keys = {
      { "<C-z>", mode = "v" },
      {
        "<C-z>",
        function()
          local mark_rows = {}

          for char in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
            local mark = vim.api.nvim_buf_get_mark(0, char)
            local mark_row = mark[1]
            if mark_row ~= 0 then
              table.insert(mark_rows, mark_row)
            end
          end

          table.sort(mark_rows)

          local cursor = vim.api.nvim_win_get_cursor(0)
          local current_row = cursor[1]
          local start_row = 1
          local end_row = vim.api.nvim_buf_line_count(0)

          for _, mark_row in ipairs(mark_rows) do
            if mark_row <= current_row then
              start_row = mark_row
            else
              end_row = mark_row - 1
              break
            end
          end

          vim.api.nvim_win_set_cursor(0, { start_row, 0 })
          vim.cmd("normal V")
          vim.api.nvim_win_set_cursor(0, { end_row, 0 })
          require("iron.core").visual_send()
          vim.api.nvim_win_set_cursor(0, cursor)
        end,
      },
      { "<space>r", "<Cmd>IronRepl<CR>", desc = "REPL" },
      { "<space>z", desc = "Send to REPL" },
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
            return table.concat(colorscheme, " ")
          end,
        },
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
    "chentoast/marks.nvim",
    opts = {
      sign_priority = 13,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ansible-lint",
        "black",
        "eslint_d",
        "fixjson",
        "isort",
        "js-debug-adapter",
        "mypy",
        "prettierd",
        "ruff",
        "shellcheck",
        "shellharden",
        "shfmt",
        "stylua",
        "taplo",
        "yamlfmt",
        "yamllint",
      },
    },
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
      local run_if_not_pypackages = {
        runtime_condition = function(params)
          return not params.lsp_params.textDocument.uri:find("/__pypackages__/")
        end,
      }
      opts.sources = {
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.mypy.with(run_if_not_pypackages),
        null_ls.builtins.diagnostics.ruff.with(run_if_not_pypackages),
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
        null_ls.builtins.formatting.taplo,
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
            if Bqf_preview_timer and Bqf_preview_timer:get_due_in() > 0 then
              Bqf_preview_timer:stop()
              Bqf_preview_timer = nil
            end
            Bqf_preview_timer = vim.defer_fn(function()
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
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
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
        omap     <silent> p :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> p :lua require('tsht').nodes()<CR>
      ]])
    end,
    event = "BufReadPost",
    init = function()
      require("which-key").register({
        p = "Nodes",
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
        "toml",
      })
      opts.rainbow = {
        enable = true,
        extended_mode = true,
      }
      opts.textobjects = {
        lsp_interop = {},
        move = {},
        select = {
          enable = true,
          keymaps = {
            ["=l"] = "@assignment.lhs",
            ["=r"] = "@assignment.rhs",
          },
          lookahead = true,
        },
        swap = {},
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
    "vuki656/package-info.nvim",
    config = true,
    ft = "json",
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSHighlightCapturesUnderCursor",
      "TSPlaygroundToggle",
    },
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git" },
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
    "rmagatti/session-lens",
    keys = {
      {
        "<space>sS",
        function()
          require("session-lens").search_session()
        end,
        desc = "Sessions",
      },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPost",
    opts = {
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
    config = function()
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_style = colorscheme[2]
    end,
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
    event = "InsertEnter",
    opts = {
      completion = false,
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
    keys = {
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        mode = { "n", "t" },
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
        mode = { "n", "t" },
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
        mode = { "n", "t" },
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        mode = { "n", "t" },
      },
    },
    opts = {
      resize = {
        enable_default_keybindings = false,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = colorscheme[2],
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
      local register = require("which-key").register

      for _, key in ipairs({
        "<C-L>",
        "<C-Q>",
        "<C-T>",
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
        "T",
        "u",
        "x",
        "y",
      }) do
        register({
          ["[" .. key] = "which_key_ignore",
          ["]" .. key] = "which_key_ignore",
        })
      end
    end,
    keys = {
      { "[<space>", desc = "Add blank lines above" },
      { "]<space>", desc = "Add blank lines below" },
      { "[p", desc = "Paste before linewise" },
      { "]p", desc = "Paste after linewise" },
      { "[q", desc = "Previous item in quickfix list" },
      { "]q", desc = "Next item in quickfix list" },
      { "[Q", desc = "First item in quickfix list" },
      { "]Q", desc = "Last item in quickfix list" },
    },
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
