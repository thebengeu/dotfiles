return {
  {
    "akinsho/bufferline.nvim",
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

      opts.options.always_show_bufferline = true
      opts.options.offsets = {}
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
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
    "jinh0/eyeliner.nvim",
    init = function()
      local add_bold_and_underline = function(name)
        vim.api.nvim_set_hl(0, name, {
          bold = true,
          fg = vim.api.nvim_get_hl(0, { name = name }).fg,
          underline = true,
        })
      end

      local callback = function()
        add_bold_and_underline("EyelinerPrimary")
        add_bold_and_underline("EyelinerSecondary")
      end

      callback()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = callback,
      })
    end,
    event = "LazyFile",
    opts = {
      disabled_filetypes = {
        "copilot-chat",
        "help",
        "lazy",
        "minifiles",
        "qf",
        "snacks_picker_list",
        "snacks_terminal",
        "trouble",
      },
    },
    vscode = true,
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
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "/" },
      { "?" },
      {
        "n",
        "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
      },
      {
        "N",
        "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
      },
      { "*", "*<cmd>lua require('hlslens').start()<cr>" },
      { "#", "#<cmd>lua require('hlslens').start()<cr>" },
      {
        "g*",
        "g*<cmd>lua require('hlslens').start()<cr>",
        desc = "Search word forward",
      },
      {
        "g#",
        "g#<cmd>lua require('hlslens').start()<cr>",
        desc = "Search word backward",
      },
    },
    opts = {
      calm_down = true,
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
