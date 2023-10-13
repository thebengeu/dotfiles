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
          enabled = false,
        },
      }, jit.os == "Windows" and {} or { ansiblels = {} })
      opts.setup = vim.tbl_extend("force", opts.setup, {
        clangd = function(_, clangd_opts)
          clangd_opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    config = function(_, opts)
      local Util = require("lazyvim.util")

      require("typescript-tools").setup(opts)

      local function get_client(buf)
        return Util.lsp.get_clients({
          name = "typescript-tools",
          bufnr = buf,
        })[1]
      end

      Util.format.register(Util.lsp.formatter({
        name = "typescript-tools",
        primary = false,
        priority = 300,
        filter = "typescript-tools",
        sources = function(buf)
          local client = get_client(buf)
          return client and { "typescript-tools" } or {}
        end,
        format = function(buf)
          local c = require("typescript-tools.protocol.constants")

          local client = get_client(buf)

          if client then
            local diagnostics = vim.diagnostic.get(buf)

            for _, error_codes_and_fix_names in ipairs({
              {
                { 2420, 1308, 7027 },
                {
                  "fixClassIncorrectlyImplementsInterface",
                  "fixAwaitInSyncFunction",
                  "fixUnreachableCode",
                },
              },
              {
                { 6196, 6133 },
                { "unusedIdentifier" },
              },
              {
                { 2552, 2304 },
                { "import" },
              },
            }) do
              local res =
                client.request_sync(c.CustomMethods.BatchCodeActions, {
                  bufnr = buf,
                  diagnostics = diagnostics,
                  error_codes = error_codes_and_fix_names[1],
                  fix_names = error_codes_and_fix_names[2],
                }, 1000, buf)

              if res and not res.err then
                vim.lsp.util.apply_workspace_edit(res.result.edit, "utf-8")
              end
            end

            local res =
              vim.lsp.buf_request_sync(buf, c.CustomMethods.OrganizeImports, {
                file = vim.api.nvim_buf_get_name(buf),
                mode = c.OrganizeImportsMode.All,
              }, 1000)

            if res then
              local typescript_client_res = res[client.id]
              if not typescript_client_res.err then
                vim.lsp.util.apply_workspace_edit(
                  typescript_client_res.result,
                  "utf-8"
                )
              end
            end
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
