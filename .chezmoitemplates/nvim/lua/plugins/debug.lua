return {
  {
    "nvim-telescope/telescope-dap.nvim",
    keys = {
      {
        "<leader>dL",
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        desc = "List Breakpoints",
      },
    },
  },
}
