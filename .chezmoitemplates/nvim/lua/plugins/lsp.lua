local Util = require("lazyvim.util")

return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>uF",
        function()
          Util.format.toggle()
        end,
        desc = "Toggle auto format (global)",
      },
      {
        "<leader>uf",
        function()
          Util.format.toggle(true)
        end,
        desc = "Toggle auto format (buffer)",
      },
    },
    opts = {
      formatters = {
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
      },
      formatters_by_ft = {
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
        ["*"] = { "typos" },
        ["_"] = { "trim_newlines", "trim_whitespace" },
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    lazy = true,
    opts = {},
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
        "js-debug-adapter",
        "mypy",
        "shellcheck",
        "shellharden",
        "sql-formatter",
        "sqlfluff",
        "taplo",
        "typescript-language-server",
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
        -- typos_lsp = {},
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

          local client = get_client(bufnr)

          if not client then
            return
          end

          local file = vim.api.nvim_buf_get_name(bufnr)

          api.add_missing_imports(true)

          if not file:match("supabase") then
            api.organize_imports(true)
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
        code_lens = "all",
        complete_function_calls = true,
        expose_as_code_action = "all",
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
