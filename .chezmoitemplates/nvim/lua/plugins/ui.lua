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
      unpack(vim
        .iter({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
        :map(function(i)
          return {
            "<C-" .. i % 10 .. ">",
            function()
              require("bufferline").go_to(i, true)
            end,
          }
        end)
        :totable()),
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
    "stevearc/quicker.nvim",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
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
  {
    "xiyaowong/transparent.nvim",
    opts = {
      extra_groups = {
        "NormalFloat",
      },
    },
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    keys = { "v", "V", "<C-v>" },
    opts = {},
  },
}
