return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            adapters = { "pwa-node" },
            debugger_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path(),
          })
          require("dap").configurations.typescript = {
            {
              cwd = "${workspaceFolder}",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              request = "attach",
              type = "pwa-node",
            },
            {
              console = "integratedTerminal",
              cwd = "${workspaceFolder}",
              name = "ts-node/esm/transpile-only",
              program = "${file}",
              request = "launch",
              runtimeArgs = { "--loader", "ts-node/esm/transpile-only" },
              type = "pwa-node",
            },
          }
        end,
      },
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    keys = {
      {
        "<leader>dB",
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        desc = "List Breakpoints",
      },
    },
  },
}
