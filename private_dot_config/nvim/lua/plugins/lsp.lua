local api = vim.api

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ansible-lint",
        "black",
        "curlylint",
        "djlint",
        "fixjson",
        "isort",
        "js-debug-adapter",
        "ruff",
        "shellcheck",
        "shellharden",
        "shfmt",
        "sqlfluff",
        "stylua",
        "taplo",
        "yamlfmt",
        "yamllint",
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local run_if_not_venv = {
        runtime_condition = function(params)
          return not params.lsp_params.textDocument.uri:find("/.venv/")
        end,
      }
      opts.sources = {
        null_ls.builtins.diagnostics.curlylint.with({
          extra_filetypes = { "jinja" },
        }),
        null_ls.builtins.diagnostics.djlint.with({
          extra_filetypes = { "jinja" },
        }),
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.mypy.with(run_if_not_venv),
        null_ls.builtins.diagnostics.ruff.with(run_if_not_venv),
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "postgres" },
          timeout = 20000,
        }),
        null_ls.builtins.diagnostics.yamllint.with({
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:find("/Pulumi%.")
          end,
        }),
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.djlint.with({
          extra_filetypes = { "jinja" },
        }),
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.isort.with({
          extra_args = { "--profile", "black" },
        }),
        null_ls.builtins.formatting.prettier.with({
          extra_filetypes = { "prisma" },
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:find("/ccxt/")
          end,
        }),
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.taplo,
        null_ls.builtins.formatting.yamlfmt,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function(plugin, opts)
      local super = plugin._.super
      super.config(super, opts)

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
      servers = {
        ansiblels = {},
        bashls = {},
        graphql = {},
        prismals = {},
        pyright = {
          on_attach = function(client)
            client.handlers["textDocument/publishDiagnostics"] = function(_, result, context, config)
              local diagnostics = {}

              for _, diagnostic in ipairs(result.diagnostics) do
                if
                    not string.match(diagnostic.message, '"_.+" is not accessed')
                    and not diagnostic.message == "models is not accessed"
                then
                  table.insert(diagnostics, diagnostic)
                end
              end

              result.diagnostics = diagnostics

              vim.lsp.diagnostic.on_publish_diagnostics(_, result, context, config)
            end
          end,
        },
        tsserver = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            api.nvim_create_autocmd("BufWritePre", {
              callback = function()
                if vim.api.nvim_buf_get_name(0):find("/ccxt/") then
                  return
                end
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
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if vim.api.nvim_buf_get_name(0):find("/ccxt/") then
                return
              end

              local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end,
          })
        end,
      },
    },
  },
}

