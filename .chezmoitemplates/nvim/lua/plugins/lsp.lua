local LazyVim = require("lazyvim.util")

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
              dataTypeCase = "lower",
              functionCase = "lower",
              keywordCase = "lower",
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
        sql = { "sqlfmt", "trim_newlines" },
        ["_"] = { "trim_newlines", "trim_whitespace" },
      })

      for ft, formatters in pairs(formatters_by_ft) do
        opts.formatters_by_ft[ft] = vim
          .iter(formatters)
          :map(function(formatter)
            return formatter == "prettier" and "prettierd" or formatter
          end)
          :totable()
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
        "sqlfmt",
        "taplo",
        "yamllint",
      })
      if jit.os == "Linux" then
        vim.list_extend(opts.ensure_installed, { "ansible-lint" })
      end
      if not (jit.os == "Linux" and jit.arch == "arm64") then
        vim.list_extend(opts.ensure_installed, { "typos" })

        if jit.os ~= "Windows" then
          vim.list_extend(opts.ensure_installed, { "zprint" })
        end
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics.virtual_text = false
      opts.servers.bashls = vim.tbl_deep_extend("error", opts.servers.bashls, {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(_, result, ...)
            local filename =
              vim.fn.fnamemodify(vim.uri_to_fname(result.uri), ":t")

            if string.match(filename, ".env$") then
              return
            end

            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
          end,
        },
      })
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
            ...
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

            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
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
