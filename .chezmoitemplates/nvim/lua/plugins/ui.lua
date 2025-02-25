return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      {
        "<A-w>",
        function()
          Snacks.bufdelete()
        end,
      },
      {
        "<C-1>",
        function()
          require("bufferline").go_to(1, true)
        end,
      },
      {
        "<C-2>",
        function()
          require("bufferline").go_to(2, true)
        end,
      },
      {
        "<C-3>",
        function()
          require("bufferline").go_to(3, true)
        end,
      },
      {
        "<C-4>",
        function()
          require("bufferline").go_to(4, true)
        end,
      },
      {
        "<C-5>",
        function()
          require("bufferline").go_to(5, true)
        end,
      },
      {
        "<C-6>",
        function()
          require("bufferline").go_to(6, true)
        end,
      },
      {
        "<C-7>",
        function()
          require("bufferline").go_to(7, true)
        end,
      },
      {
        "<C-8>",
        function()
          require("bufferline").go_to(8, true)
        end,
      },
      {
        "<C-9>",
        function()
          require("bufferline").go_to(9, true)
        end,
      },
      {
        "<C-0>",
        function()
          require("bufferline").go_to(10, true)
        end,
      },
    },
    opts = function(_, opts)
      local Offset = require("bufferline.offset")
      local get = Offset.get

      ---@diagnostic disable-next-line: duplicate-set-field
      Offset.get = function()
        ---@diagnostic disable-next-line: undefined-field
        local edgy = package.loaded.edgy
        ---@diagnostic disable-next-line: undefined-field
        package.loaded.edgy = nil

        local ret = get()

        ---@diagnostic disable-next-line: undefined-field
        package.loaded.edgy = edgy

        return ret
      end

      opts.options = vim.tbl_deep_extend("force", opts.options, {
        always_show_bufferline = true,
        numbers = function(params)
          return params.ordinal
        end,
        offsets = {},
        show_buffer_close_icons = false,
        show_close_icon = false,
        tab_size = 1,
      })
    end,
  },
  {
    "folke/edgy.nvim",
    opts = {
      animate = { enabled = false },
      keys = {
        ["<A-h>"] = function(win)
          win:resize(
            "width",
            require("edgy").get_win().view.edgebar.pos == "right" and 2 or -2
          )
        end,
        ["<A-j>"] = function(win)
          win:resize("height", -2)
        end,
        ["<A-k>"] = function(win)
          win:resize("height", 2)
        end,
        ["<A-l>"] = function(win)
          win:resize(
            "width",
            require("edgy").get_win().view.edgebar.pos == "right" and -2 or 2
          )
        end,
      },
      wo = {
        winbar = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            any = {
              { find = "%d+ change" },
              { find = "%d+L, %d+B" },
              { kind = "search_count" },
            },
          },
          opts = {
            skip = true,
          },
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    keys = {
      {
        "<leader>fs",
        function()
          require("rip-substitute").sub()
        end,
        desc = "Rip Substitute",
        mode = { "n", "x" },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
  },
  {
    "lewis6991/satellite.nvim",
    event = "LazyFile",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").add({
          { "<LeftMouse>", hidden = true, mode = { "i", "n", "o", "x" } },
        })
      end)
    end,
    opts = {},
  },
}
