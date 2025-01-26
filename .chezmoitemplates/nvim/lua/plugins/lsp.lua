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
        ["markdownlint-cli2"] = {
          condition = function(ctx)
            local filename = ctx.filename

            return not filename:match("/Obsidian/")
              or filename:match("/.local/share/chezmoi/")
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
        go = { "golangcilint" },
        python = { "mypy" },
        sql = { "sqlfluff" },
        yaml = { "yamllint" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "fixjson",
        "golangci-lint",
        "mypy",
        "prettierd",
        "shellharden",
        "sql-formatter",
        "sqlfluff",
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
    opts = function(_, opts)
      opts.servers.clangd.mason = false
      opts.servers.lua_ls.settings.Lua =
        vim.tbl_extend("error", opts.servers.lua_ls.settings.Lua, {
          diagnostics = {
            globals = { "hs", "spoon", "vim" },
          },
        })
      opts.servers.pyright = vim.tbl_extend("error", opts.servers.pyright, {
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
      })
      opts.servers.vtsls.settings.typescript.inlayHints.functionLikeReturnTypes.enabled =
        false
      opts.servers.vtsls.settings.typescript.inlayHints.parameterTypes.enabled =
        false
      opts.servers.yamlls =
        require("schema-companion").setup_client(opts.servers.yamlls)

      opts.servers = vim.tbl_extend("error", opts.servers, {
        dagger = {},
        graphql = {},
        powershell_es = {
          enabled = vim.fn.executable("pwsh") == 1,
        },
        -- typos_lsp = {},
      }, jit.os == "Linux" and { ansiblels = {} } or {})

      opts.setup.clangd = function(_, clangd_opts)
        clangd_opts.capabilities.offsetEncoding = { "utf-16" }
      end
    end,
  },
}
