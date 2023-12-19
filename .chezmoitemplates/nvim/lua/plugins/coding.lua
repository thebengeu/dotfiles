local clangd_specs = require("lazyvim.plugins.extras.lang.clangd")
local util = require("util")

return vim.list_extend(
  util.filter(clangd_specs, function(spec)
    return spec[1] ~= "nvim-cmp"
  end),
  {
    {
      "p00f/clangd_extensions.nvim",
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("cmp").setup.filetype({ "c", "cpp" }, {
          ---@diagnostic disable-next-line: missing-fields
          sorting = {
            comparators = vim.list_extend(
              { require("clangd_extensions.cmp_scores") },
              require("cmp.config").global.sorting.comparators
            ),
          },
        })
      end,
      ft = { "c", "cpp" },
    },
    {
      "DNLHC/glance.nvim",
      keys = {
        { "gd", "<Cmd>Glance definitions<cr>", desc = "Goto Definition" },
        {
          "gI",
          "<Cmd>Glance implementations<cr>",
          desc = "Goto Implementation",
        },
        { "gr", "<Cmd>Glance references<cr>", desc = "References" },
        {
          "gt",
          "<Cmd>Glance type_definitions<cr>",
          desc = "Goto Type Definition",
        },
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
            or vim.fn.fnamemodify(
              vim.api.nvim_buf_get_name(current_bufnr),
              ":h"
            )

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
            repl_open_cmd = require("iron.view").split.horizontal.botright(
              20,
              {
                number = false,
                relativenumber = false,
              }
            ),
          },
          keymaps = {
            send_motion = "<leader>cz",
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
            vim.cmd.normal("V")
            vim.api.nvim_win_set_cursor(0, { end_row, 0 })
            require("iron.core").visual_send()
            vim.api.nvim_win_set_cursor(0, cursor)
          end,
        },
        { "<leader>cR", "<Cmd>IronRepl<CR>", desc = "REPL" },
        { "<leader>cz", desc = "Send to REPL" },
      },
    },
    {
      "rafcamlet/nvim-luapad",
      keys = {
        { "<leader>cL", "<Cmd>Luapad<CR>", desc = "Luapad" },
      },
    },
    {
      "L3MON4D3/LuaSnip",
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
    },
    {
      "echasnovski/mini.ai",
      init = function()
        local Util = require("lazyvim.util")

        Util.on_load("mini.ai", function()
          Util.on_load("which-key.nvim", function()
            require("which-key").register({
              af = "Function call",
              ["if"] = "Function call",
              mode = { "o", "x" },
            })
          end)
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
      "echasnovski/mini.comment",
      cond = not vim.g.vscode,
    },
    {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        opts.mapping = vim.tbl_extend("error", opts.mapping, {
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
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        vim.treesitter.language.register("lua", "lua.chezmoitmpl")

        vim.list_extend(opts.ensure_installed, {
          "cue",
          "fennel",
          "fish",
          "hjson",
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
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        multiline_threshold = 1,
      },
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      cond = not vim.g.vscode,
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
          "<Cmd>lua require('various-textobjs')."
            .. textobj[#textobj]
            .. "("
            .. (#textobj == 2 and "'" .. textobj[1] .. "'" or "")
            .. ")<CR>",
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
      ft = "json",
      keys = {
        {
          "<leader>cp",
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
      "ThePrimeagen/refactoring.nvim",
      keys = {
        {
          "<leader>cF",
          function()
            require("telescope").extensions.refactoring.refactors()
          end,
          desc = "Refactor",
          mode = { "n", "v" },
        },
      },
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
      vscode = true,
    },
    {
      "tpope/vim-dadbod",
      keys = {
        {
          "<leader>cq",
          function()
            local node = vim.treesitter.get_node()

            while node and node:type() ~= "statement" do
              node = node:parent()
            end

            if node then
              local start_row, _, end_row, _ = node:range()
              vim.cmd.DB({ range = { start_row + 1, end_row + 1 } })
            end
          end,
          desc = "Query DB",
          ft = "sql",
        },
        {
          "<leader>cq",
          ":DB<CR>",
          desc = "Query DB",
          ft = "sql",
          mode = "x",
        },
      },
    },
    {
      "kristijanhusak/vim-dadbod-completion",
      dependencies = {
        "tpope/vim-dadbod",
        "hrsh7th/nvim-cmp",
      },
      ft = "sql",
    },
    {
      "kristijanhusak/vim-dadbod-ui",
      config = function()
        vim.g.db_ui_use_nerd_fonts = 1
      end,
      dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-completion",
      },
      keys = {
        { "<leader>cD", "<Cmd>DBUIToggle<CR>", desc = "Dadbod UI" },
      },
    },
    {
      "andymass/vim-matchup",
      config = function()
        require("lazyvim.util").on_load("which-key.nvim", function()
          require("which-key").register({
            ["a%"] = "any block",
            ["i%"] = "inner any block",
          }, { mode = "o" })
        end)
      end,
      event = "LazyFile",
      vscode = true,
    },
  }
)
