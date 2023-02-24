return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap")
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    end,
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>du",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
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
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
    dependencies = "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dU",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    keys = {
      {
        "<leader>dl",
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        desc = "List Breakpoints",
      },
    },
  },
}
