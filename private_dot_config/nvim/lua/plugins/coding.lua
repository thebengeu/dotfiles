local api = vim.api

return {
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
            open()
          end
        end,
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    config = true,
    lazy = true,
  },
  {
    "/hkupty/iron.nvim",
    config = function()
      local ts = require("iron.fts.typescript").ts

      require("iron.core").setup({
        config = {
          repl_definition = {
            python = require("iron.fts.python").ipython,
            sql = {
              command = { "psql", "postgresql://postgres:postgres@localhost:5432/postgres" },
            },
            typescript = vim.tbl_extend("force", ts, {
              command = { "ts-node", "--compilerOptions", '{"module": "commonjs"}' },
              format = function(lines)
                for i, line in ipairs(lines) do
                  lines[i] = line:gsub("const ", "")
                end
                return require("iron.fts.common").format(ts, lines)
              end,
            }),
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
            local mark = api.nvim_buf_get_mark(0, char)
            local mark_row = mark[1]
            if mark_row ~= 0 then
              table.insert(mark_rows, mark_row)
            end
          end

          table.sort(mark_rows)

          local cursor = api.nvim_win_get_cursor(0)
          local current_row = cursor[1]
          local start_row = 1
          local end_row = api.nvim_buf_line_count(0)

          for _, mark_row in ipairs(mark_rows) do
            if mark_row <= current_row then
              start_row = mark_row
            else
              end_row = mark_row - 1
              break
            end
          end

          api.nvim_win_set_cursor(0, { start_row, 0 })
          vim.cmd("normal V")
          api.nvim_win_set_cursor(0, { end_row, 0 })
          require("iron.core").visual_send()
          api.nvim_win_set_cursor(0, cursor)
        end,
      },
      { "<space>r", "<Cmd>IronRepl<CR>", desc = "REPL" },
      { "<space>z", desc = "Send to REPL" },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "echasnovski/mini.ai",
    config = function(plugin, opts)
      local super = plugin._.super
      super.config(super, opts)

      require("which-key").register({
        af = "Function call",
        ["if"] = "Function call",
        mode = { "o", "x" },
      })
    end,
    keys = {
      { "ad", desc = "Function definition", mode = { "o", "x" } },
      { "id", desc = "Function definition", mode = { "o", "x" } },
    },
    opts = function(_, opts)
      opts.custom_textobjects.d = opts.custom_textobjects.f
      opts.custom_textobjects.f = nil
    end,
  },
  {
    "nvim-neotest/neotest",
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
        },
      })
    end,
    dependencies = {
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
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
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "tpope/vim-dadbod" },
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
        -- { name = "vim-dadbod-completion" },
      }))
    end,
  },
  {
    "mfussenegger/nvim-treehopper",
    keys = {
      { "o", ":<C-U>lua require('tsht').nodes()<CR>", desc = "Nodes", mode = "o" },
      {
        "o",
        ":lua require('tsht').nodes()<CR>",
        desc = "Nodes",
        mode = "x",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        keys = {
          {
            ";",
            function()
              require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move()
            end,
            desc = "Last move",
            mode = { "n", "o", "x" },
          },
          {
            ",",
            function()
              require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_opposite()
            end,
            desc = "Last move opposite",
            mode = { "n", "o", "x" },
          },
        },
      },
    },
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "fish",
        "gitignore",
        "prisma",
        "sql",
        "toml",
      })
      opts.matchup = {
        disable_virtual_text = true,
        enable = true,
      }
      opts.rainbow = {
        enable = true,
        extended_mode = true,
      }
      opts.textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ql"] = {
              desc = "Select assignment LHS",
              query = "@assignment.lhs",
            },
            ["qr"] = {
              desc = "Select assignment RHS",
              query = "@assignment.rhs",
            },
          },
          lookahead = true,
        },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true,
    event = "InsertEnter",
  },
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = {
          {
            pattern = "/src/.+/(.+).py$",
            target = "/tests/test_%1.py",
          },
          {
            pattern = "/tests/test_(.+).py$",
            target = "/src/*/%1.py",
          },
        },
      })
    end,
    keys = {
      { "<space>fo", "<Cmd>Other<CR>", desc = "Open other file" },
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
    "Wansmer/treesj",
    keys = {
      { "J", "<Cmd>TSJToggle<CR>" },
    },
    opts = {
      use_default_keymaps = false,
    },
  },
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },
  {
    "andymass/vim-matchup",
    config = function()
      require("which-key").register({
        ["a%"] = "any block",
        ["i%"] = "inner any block",
      }, { mode = "o" })
    end,
    event = { "BufNewFile", "BufReadPost" },
  },
}
