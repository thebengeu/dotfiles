return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = function()
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

          return {
            adapters = { "pwa-node" },
            debugger_path = vim.loop.os_homedir() .. "/vscode-js-debug",
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
