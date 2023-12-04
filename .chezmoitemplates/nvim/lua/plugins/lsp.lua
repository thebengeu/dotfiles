return {
  {
    "stevearc/conform.nvim",
    enabled = false,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false,
  },
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
        "typescript-language-server",
        "yamlfmt",
        "yamllint",
        "zprint",
      }, jit.os == "Linux" and { "ansible-lint" } or {}),
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
            return not params.lsp_params.textDocument.uri:match("%.env")
          end,
          extra_args = { "-e", "SC1017" },
        }),
        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "postgres" },
          timeout = 20000,
        }),
        null_ls.builtins.diagnostics.yamllint.with({
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:match("/Pulumi%.")
          end,
        }),
        null_ls.builtins.formatting.cue_fmt,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = { "prisma" },
          runtime_condition = function(params)
            return not params.lsp_params.textDocument.uri:match("/ccxt/")
          end,
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.taplo,
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.formatting.zprint,
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
    opts = {
      inlay_hints = {
        enabled = true,
      },
      servers = vim.tbl_extend("error", {
        bashls = {},
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
        prismals = {},
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
        tsserver = {
          enabled = false,
        },
      }, jit.os == "Linux" and { ansiblels = {} } or {}),
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    config = function(_, opts)
      local Util = require("lazyvim.util")

      require("typescript-tools").setup(opts)

      local function get_client(bufnr)
        return Util.lsp.get_clients({
          name = "typescript-tools",
          bufnr = bufnr,
        })[1]
      end

      Util.format.register(Util.lsp.formatter({
        name = "typescript-tools",
        primary = false,
        priority = 50,
        filter = "typescript-tools",
        sources = function(bufnr)
          local client = get_client(bufnr)
          return client and { "typescript-tools" } or {}
        end,
        format = function(bufnr)
          local api = require("typescript-tools.api")
          local c = require("typescript-tools.protocol.constants")

          local client = get_client(bufnr)

          if client then
            local request = function()
              local file = vim.api.nvim_buf_get_name(bufnr)

              client.request(c.CustomMethods.OrganizeImports, {
                file = file,
                mode = c.OrganizeImportsMode.All,
              }, function(err, result)
                if not file:match("supabase") then
                  vim.lsp.handlers[c.CustomMethods.OrganizeImports](err, result)
                end

                vim.api.nvim_buf_call(bufnr, function()
                  local autoformat = vim.b.autoformat
                  vim.b.autoformat = false
                  vim.cmd.update()
                  vim.b.autoformat = autoformat
                end)
              end, bufnr)
            end

            for _, error_codes_and_fix_names in ipairs({
              {
                { 2552, 2304 },
                { "import" },
              },
              {
                { 6196, 6133 },
                { "unusedIdentifier" },
              },
              {
                { 2420, 1308, 7027 },
                {
                  "fixClassIncorrectlyImplementsInterface",
                  "fixAwaitInSyncFunction",
                  "fixUnreachableCode",
                },
              },
            }) do
              local error_codes, fix_names =
                error_codes_and_fix_names[1], error_codes_and_fix_names[2]

              local callback = request
              request = function()
                client.request(c.CustomMethods.BatchCodeActions, {
                  bufnr = bufnr,
                  diagnostics = vim.diagnostic.get(bufnr),
                  error_codes = error_codes,
                  fix_names = fix_names,
                }, function(_, result)
                  if result.edit.changes then
                    vim.lsp.util.apply_workspace_edit(result.edit, "utf-8")

                    if fix_names[1] ~= "import" then
                      api.request_diagnostics(callback)
                      return
                    end
                  end

                  callback()
                end, bufnr)
              end
            end

            request()
          end
        end,
      }))
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = {
      "typescript",
      "typescriptreact",
    },
    opts = {
      settings = {
        tsserver_file_preferences = {
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
}
