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
    "Vigemus/iron.nvim",
    config = function()
      local config = require("iron.config")

      ---@diagnostic disable-next-line: duplicate-set-field
      require("iron.lowlevel").create_repl_on_current_window = function(ft, repl, bufnr, current_bufnr, opts)
        vim.api.nvim_win_set_buf(0, bufnr)
        -- TODO Move this out of this function
        -- Checking config should be done on an upper layer.
        -- This layer should be simpler
        opts = opts or {}
        opts.cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(current_bufnr), ":h")
        if config.close_window_on_exit then
          opts.on_exit = function()
            local bufwinid = vim.fn.bufwinid(bufnr)
            while bufwinid ~= -1 do
              vim.api.nvim_win_close(bufwinid, true)
              bufwinid = vim.fn.bufwinid(bufnr)
            end
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end

        local cmd = repl.command
        if type(repl.command) == "function" then
          local meta = {
            current_bufnr = current_bufnr,
          }
          cmd = repl.command(meta)
        end
        local job_id = vim.fn.termopen(cmd, opts)

        return {
          ft = ft,
          bufnr = bufnr,
          job = job_id,
          repldef = repl,
        }
      end

      local ts = require("iron.fts.typescript").ts
      local typescript = vim.tbl_extend("force", ts, {
        command = { "pnpm", "tsx" },
        format = function(lines)
          for i, line in ipairs(lines) do
            lines[i] = line
              :gsub("const ", "var ")
              :gsub("^import ", "var ")
              :gsub("( from '%S+)%.js'$", "%1'")
              :gsub("(, {.+} from '(%S+)')$", " = require('%2')%1")
              :gsub(" from '(%S+)'$", " = require('%1')")
              :gsub(" type ", " ")
          end
          return require("iron.fts.common").format(ts, lines)
        end,
      })

      require("iron.core").setup({
        config = {
          repl_definition = {
            sql = {
              command = { "psql", "postgresql://postgres:postgres@localhost:5432/postgres" },
            },
            typescript = typescript,
            typescriptreact = typescript,
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
    init = function()
      require("lazyvim.util").on_load("mini.ai", function()
        require("which-key").register({
          af = "Function call",
          ["if"] = "Function call",
          mode = { "o", "x" },
        })
      end)
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "tpope/vim-dadbod" },
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
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
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "vim-dadbod-completion" },
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
      vim.list_extend(opts.ensure_installed, {
        "cue",
        "fish",
        "gitignore",
        "prisma",
        "sql",
        "toml",
      })
      opts.indent = {
        disable = { "yaml" },
      }
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
    "chrisgrieser/nvim-various-textobjs",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      useDefaultKeymaps = true,
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
    "axelvc/template-string.nvim",
    config = true,
    ft = "typescript",
  },
  {
    "folke/todo-comments.nvim",
    enabled = false,
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
