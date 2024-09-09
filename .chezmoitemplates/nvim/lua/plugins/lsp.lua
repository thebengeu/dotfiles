local LazyVim = require("lazyvim.util")
local util = require("util")

return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>uF",
        function()
          LazyVim.format.toggle()
        end,
        desc = "Toggle auto format (global)",
      },
      {
        "<leader>uf",
        function()
          LazyVim.format.toggle(true)
        end,
        desc = "Toggle auto format (buffer)",
      },
    },
    opts = function(_, opts)
      opts.formatters = vim.tbl_extend("force", opts.formatters, {
        sql_formatter = {
          prepend_args = {
            "--config",
            vim.fn.json_encode({
              dataTypeCase = "upper",
              functionCase = "upper",
              keywordCase = "upper",
              language = "bigquery",
            }),
          },
        },
      })

      local formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, {
        c = { "clang_format" },
        clojure = { "zprint" },
        cue = { "cue_fmt" },
        json = { "fixjson", "prettier" },
        just = { "just" },
        markdown = { "markdownlint", "prettier" },
        prisma = { "prettier" },
        python = { "ruff_fix", "ruff_format" },
        toml = { "taplo" },
        sh = { "shellharden", "shellcheck", "shfmt" },
        sql = { "sql_formatter" },
        ["_"] = { "trim_newlines", "trim_whitespace" },
      })

      for ft, formatters in pairs(formatters_by_ft) do
        opts.formatters_by_ft[ft] = util.map(formatters, function(formatter)
          return formatter == "prettier" and "prettierd" or formatter
        end)
      end
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          condition = function(ctx)
            local filename = ctx.filename

            return filename:match("/.local/share/chezmoi/")
              or filename:match("/supabase/")
              or filename:match("/thebengeu/")
          end,
        },
        yamllint = {
          condition = function(ctx)
            return not ctx.filename:match("/Pulumi%.")
          end,
        },
      },
      linters_by_ft = {
        python = { "mypy" },
        yaml = { "yamllint" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "fixjson",
        "mypy",
        "prettierd",
        "shellharden",
        "sql-formatter",
        "taplo",
        "typos",
        "yamllint",
      })
      if jit.os == "Linux" then
        vim.list_extend(opts.ensure_installed, { "ansible-lint" })
      end
      if jit.os ~= "Windows" then
        vim.list_extend(opts.ensure_installed, { "zprint" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      table.insert(keys, { "[d", false })
      table.insert(keys, { "[e", false })
      table.insert(keys, { "[w", false })
      table.insert(keys, { "]d", false })
      table.insert(keys, { "]e", false })
      table.insert(keys, { "]w", false })
      table.insert(keys, { "gI", false })
      table.insert(keys, { "gd", false })
      table.insert(keys, { "gr", false })
      table.insert(keys, { "gt", false })
    end,
    opts = {
      servers = vim.tbl_extend("error", {
        clangd = {
          mason = false,
        },
        dagger = {},
        graphql = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "hs", "spoon", "vim" },
              },
            },
          },
        },
        powershell_es = {
          enabled = vim.fn.executable("pwsh") == 1,
        },
        pyright = {
          on_attach = function(client)
            client.handlers["textDocument/publishDiagnostics"] = function(
              _,
              result,
              context,
              config
            )
              local diagnostics = {}

              for _, diagnostic in ipairs(result.diagnostics) do
                if
                  not string.match(diagnostic.message, '"_.+" is not accessed')
                then
                  table.insert(diagnostics, diagnostic)
                end
              end

              result.diagnostics = diagnostics

              vim.lsp.diagnostic.on_publish_diagnostics(
                _,
                result,
                context,
                config
              )
            end
          end,
        },
        -- typos_lsp = {},
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = false },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
              },
            },
          },
        },
      }, jit.os == "Linux" and { ansiblels = {} } or {}),
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
}
