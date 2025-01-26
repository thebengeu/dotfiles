local util = require("util")

return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local lowlevel = require("iron.lowlevel")

      local create_repl_on_current_window =
        lowlevel.create_repl_on_current_window

      ---@diagnostic disable-next-line: duplicate-set-field
      lowlevel.create_repl_on_current_window = function(
        ft,
        repl,
        bufnr,
        current_bufnr,
        opts
      )
        opts = opts or {}
        opts.cwd = opts.cwd
          or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(current_bufnr), ":h")

        return create_repl_on_current_window(
          ft,
          repl,
          bufnr,
          current_bufnr,
          opts
        )
      end

      local ts = require("iron.fts.typescript").ts
      local typescript = vim.tbl_extend("force", ts, {
        command = { "tsx" },
        format = function(lines)
          return require("iron.fts.common").format(
            ts,
            util.map(lines, function(line)
              return (
                line
                  :gsub("const ", "var ")
                  :gsub("import 'dotenv/config'", "require('dotenv').config()")
                  :gsub("^import ", "var ")
                  :gsub("( from '%S+)%.js'$", "%1'")
                  :gsub("(, {.+} from '(%S+)')$", " = require('%2')%1")
                  :gsub(" from '(%S+)'$", " = require('%1')")
                  :gsub(" type ", " ")
              )
            end)
          )
        end,
      })

      require("iron.core").setup({
        config = {
          repl_definition = {
            ["lua.chezmoitmpl"] = require("iron.fts.lua").lua,
            python = require("iron.fts.python").ipython,
            sql = {
              command = function()
                return {
                  "psql",
                  vim.env.DATABASE_URL
                    or (
                      "postgresql://postgres:postgres@localhost:543"
                      .. (jit.os == "Windows" and 3 or 2)
                      .. "/postgres"
                    ),
                }
              end,
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
          send_motion = "<leader>cz",
          visual_send = "<C-z>",
        },
      })
    end,
    keys = {
      { "<C-z>", mode = "x" },
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
          vim.cmd.normal("V")
          vim.api.nvim_win_set_cursor(0, { end_row, 0 })
          require("iron.core").visual_send()
          vim.api.nvim_win_set_cursor(0, cursor)
        end,
      },
      { "<leader>cR", "<cmd>IronRepl<cr>", desc = "REPL" },
      { "<leader>cz", desc = "Send to REPL" },
    },
  },
  {
    "chrisgrieser/nvim-rulebook",
    keys = {
      {
        "<leader>xi",
        function()
          require("rulebook").ignoreRule()
        end,
        desc = "Ignore Rule",
      },
      {
        "<leader>xk",
        function()
          require("rulebook").lookupRule()
        end,
        desc = "Lookup Rule",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = "./snippets",
      })
    end,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        enabled = false,
      },
      {
        "thebengeu/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
        name = "my-friendly-snippets",
      },
    },
    keys = function()
      return {}
    end,
    opts = {
      enable_autosnippets = true,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
      ensure_installed = {
        "clojure",
        "cue",
        "fennel",
        "hcl",
        "hjson",
        "just",
        "make",
        "pem",
        "ssh_config",
        "toml",
      },
      highlight = {
        disable = function()
          if string.find(vim.bo.filetype, "chezmoitmpl") then
            return true
          end
        end,
      },
      indent = {
        disable = { "yaml" },
      },
      matchup = {
        disable_virtual_text = true,
        enable = true,
      },
      textobjects = {
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
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      multiline_threshold = 1,
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    keys = util.map({
      iS = { "inner", "subword" },
      aS = { "outer", "subword" },
      C = { "toNextClosingBracket" },
      Q = { "toNextQuotationMark" },
      gG = { "entireBuffer" },
      i_ = { "inner", "lineCharacterwise" },
      a_ = { "outer", "lineCharacterwise" },
      iv = { "inner", "value" },
      av = { "outer", "value" },
      ik = { "inner", "key" },
      ak = { "outer", "key" },
    }, function(textobj, lhs)
      return {
        lhs,
        "<cmd>lua require('various-textobjs')."
          .. textobj[#textobj]
          .. "("
          .. (#textobj == 2 and "'" .. textobj[1] .. "'" or "")
          .. ")<cr>",
        desc = table.concat(textobj, " "),
        mode = { "o", "x" },
      }
    end),
    opts = {
      useDefaultKeymaps = false,
    },
    vscode = true,
  },
  {
    "vuki656/package-info.nvim",
    event = "BufReadPre package.json",
    keys = {
      {
        "<leader>cu",
        function()
          require("package-info").update()
        end,
        desc = "Update Package",
        ft = "json",
      },
    },
    opts = {
      hide_up_to_date = true,
    },
  },
  {
    "cenk1cenk2/schema-companion.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    ft = "yaml",
    opts = function()
      return {
        matchers = {
          require("schema-companion.matchers.kubernetes").setup({
            version = "master",
          }),
        },
      }
    end,
  },
  {
    "axelvc/template-string.nvim",
    ft = {
      "typescript",
      "typescriptreact",
    },
    opts = {},
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>" },
    },
    opts = {
      max_join_length = 1000,
      use_default_keymaps = false,
    },
    vscode = true,
  },
}
