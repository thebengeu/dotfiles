local api = vim.api

return {
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
      table.insert(keys, { "gd", false })
      table.insert(keys, { "gI", false })
      table.insert(keys, { "gr", false })
      table.insert(keys, { "gt", false })
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
}
