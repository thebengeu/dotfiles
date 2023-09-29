return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = vim.list_extend({
        "fixjson",
        "js-debug-adapter",
        "prettierd",
        "shellcheck",
        "shellharden",
        "shfmt",
        "sqlfluff",
        "stylua",
        "taplo",
        "yamlfmt",
        "yamllint",
      }, jit.os == "Windows" and {} or { "ansible-lint" }),
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = {
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.shellcheck.with({
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:find("%.env")
          end,
          extra_args = { "-e", "SC1017" },
        }),
        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "postgres" },
          timeout = 20000,
        }),
        null_ls.builtins.diagnostics.yamllint.with({
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:find("/Pulumi%.")
          end,
        }),
        null_ls.builtins.formatting.cue_fmt,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = { "prisma" },
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:find("/ccxt/")
          end,
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.taplo,
        require("typescript.extensions.null-ls.code-actions"),
        null_ls.builtins.formatting.yamlfmt,
      }
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
      opts.inlay_hints = {
        enabled = true,
      }
      opts.servers = vim.tbl_extend("force", opts.servers, {
        bashls = {},
        clangd = {
          mason = false,
        },
        dagger = {},
        graphql = {},
        powershell_es = {},
        prismals = {},
        tsserver = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            vim.api.nvim_create_autocmd("BufWritePre", {
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
          settings = {
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "literals",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              },
            },
          },
        },
      }, jit.os == "Windows" and {} or { ansiblels = {} })
      opts.setup = vim.tbl_extend("force", opts.setup, {
        clangd = function(_, clangd_opts)
          clangd_opts.capabilities.offsetEncoding = { "utf-16" }
        end,
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if vim.api.nvim_buf_get_name(0):find("/ccxt/") then
                return
              end

              local client = vim.lsp.get_clients({
                bufnr = event.buf,
                name = "eslint",
              })[1]
              if client then
                local diag = vim.diagnostic.get(event.buf, {
                  namespace = vim.lsp.diagnostic.get_namespace(
                    client.id,
                    false
                  ),
                })
                if #diag > 0 then
                  vim.cmd.EslintFixAll()
                end
              end
            end,
          })
        end,
        tsserver = function(_, server)
          require("typescript").setup({ server = server })
          return true
        end,
      })
    end,
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    lazy = true,
  },
}
