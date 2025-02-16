local map = require("util").map

return {
  {
    "folke/flash.nvim",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").add({
          mode = { "n", "o", "x" },
          { ",", desc = "Previous match" },
          { ";", desc = "Next match" },
        })
      end)
    end,
    opts = {
      highlight = {
        backdrop = false,
      },
      label = {
        after = false,
        before = true,
        rainbow = {
          enabled = true,
        },
        uppercase = false,
      },
      modes = {
        char = {
          autohide = true,
          config = function(opts)
            opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true) == "n"
          end,
          highlight = {
            backdrop = false,
          },
          label = {
            exclude = "acdghijklrx",
          },
        },
        search = {
          enabled = true,
        },
      },
    },
    vscode = true,
  },
  {
    "chentoast/marks.nvim",
    event = "LazyFile",
    opts = {
      sign_priority = 13,
    },
  },
  {
    "echasnovski/mini.move",
    keys = function()
      local keys = {}

      for key, direction in pairs({
        h = "Left",
        j = "Down",
        k = "Up",
        l = "Right",
      }) do
        table.insert(keys, "<S-" .. direction .. ">")
        table.insert(keys, { "<M-" .. key .. ">", mode = "x" })
        table.insert(keys, {
          "<M-" .. key .. ">",
          function()
            require("mini.move").move_line(direction:lower())
          end,
          desc = "Move line " .. direction:lower(),
          mode = "i",
        })
      end

      return keys
    end,
    opts = {
      mappings = {
        line_down = "<S-Down>",
        line_left = "<S-Left>",
        line_right = "<S-Right>",
        line_up = "<S-Up>",
      },
      options = {
        reindent_linewise = false,
      },
    },
    vscode = true,
  },
  {
    "echasnovski/mini.operators",
    event = "LazyFile",
    opts = {
      exchange = {
        prefix = "gx",
      },
      replace = {
        prefix = "gR",
      },
      sort = {
        prefix = "gS",
      },
    },
    vscode = true,
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "jake-stewart/multicursor.nvim",
    keys = function()
      local mc = require("multicursor-nvim")

      return {
        {
          "<C-Up>",
          function()
            mc.lineAddCursor(-1)
          end,
          mode = { "n", "x" },
        },
        {
          "<C-Down>",
          function()
            mc.lineAddCursor(1)
          end,
          mode = { "n", "x" },
        },
        { "<C-LeftMouse>", mc.handleMouse },
        { "<C-LeftDrag>", mc.handleMouseDrag },
        {
          "<esc>",
          function()
            if not mc.cursorsEnabled() then
              mc.enableCursors()
            elseif mc.hasCursors() then
              mc.clearCursors()
            end
          end,
        },
      }
    end,
    opts = {},
    vscode = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = {
        "TelescopePrompt",
        "snacks_picker_input",
        "snacks_picker_list",
      },
      map_c_h = true,
      map_c_w = true,
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = "junegunn/fzf",
    ft = "qf",
  },
  {
    "kevinhwang91/nvim-fundo",
    dependencies = "kevinhwang91/promise-async",
    event = "LazyFile",
    make = function()
      require("fundo").install()
    end,
    opts = {},
  },
  {
    "chrisgrieser/nvim-spider",
    keys = map({ "b", "e", "ge", "w" }, function(key)
      return {
        key,
        "<cmd>lua require('spider').motion('" .. key .. "')<cr>",
        mode = { "n", "o", "x" },
      }
    end),
    vscode = true,
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
    "gbprod/substitute.nvim",
    keys = {
      {
        "x",
        function()
          require("substitute").operator()
        end,
      },
      {
        "xx",
        function()
          require("substitute").line()
        end,
      },
      {
        "X",
        function()
          require("substitute").eol()
        end,
      },
      {
        "x",
        function()
          require("substitute").visual()
        end,
        mode = "x",
      },
    },
    opts = {
      on_substitute = function(param)
        require("yanky.integration").substitute()(param)
      end,
    },
    vscode = true,
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertCharPre",
    opts = {
      act_as_shift_tab = true,
    },
  },
  {
    "johmsalas/text-case.nvim",
    keys = {
      { "ga", group = "text-case" },
      {
        "ga.",
        function()
          require("telescope").load_extension("textcase")
          require("textcase").open_telescope()
        end,
        desc = "Telescope",
        mode = { "n", "x" },
      },
    },
    opts = {},
    vscode = true,
  },
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    cond = not not vim.g.vscode,
    event = "LazyFile",
  },
  {
    "svban/YankAssassin.vim",
    event = "LazyFile",
    vscode = true,
  },
  {
    "gbprod/yanky.nvim",
    keys = vim.list_extend({
      { "y", false, mode = { "n", "x" } },
    }, vim.g.vscode and { { "<leader>p", false } } or {}),
    opts = {
      system_clipboard = {
        sync_with_ring = false,
      },
    },
    vscode = true,
  },
}
