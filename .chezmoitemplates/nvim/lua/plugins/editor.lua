local map = require("util").map

return {
  {
    "folke/flash.nvim",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").register({
          [","] = "Previous match",
          [";"] = "Next match",
          mode = { "n", "o", "x" },
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
      local keys = {
        {
          "[e",
          function()
            require("mini.move").move_line("up")
          end,
          desc = "Move line up",
        },
        {
          "]e",
          function()
            require("mini.move").move_line("down")
          end,
          desc = "Move line down",
        },
      }

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
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      map_c_h = true,
      map_c_w = true,
    },
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
        "<Cmd>lua require('spider').motion('" .. key .. "')<CR>",
        mode = { "n", "o", "x" },
      }
    end),
    vscode = true,
  },
  {
    "gbprod/substitute.nvim",
    opts = {
      on_substitute = function()
        require("yanky.integration").substitute()
      end,
    },
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
    vscode = true,
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    opts = {
      completion = false,
    },
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    dependencies = "nvim-telescope/telescope.nvim",
    keys = {
      { "ga", desc = "+text-case" },
      {
        "ga.",
        "<cmd>TextCaseOpenTelescope<CR>",
        mode = { "n", "x" },
        desc = "Telescope",
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").register({
          ["<M-i>"] = "Reference",
          mode = { "o", "x" },
        })
      end)
    end,
  },
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-g>",
        ["Find Subword Under"] = "<C-g>",
      }
    end,
    keys = {
      "<C-g>",
      "<C-Down>",
      "<C-Up>",
      "\\\\",
      "\\\\A",
    },
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
    dependencies = "kkharji/sqlite.lua",
    keys = vim.list_extend({
      { "y", false, mode = { "n", "x" } },
    }, vim.g.vscode and { { "<leader>p", false } } or {}),
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
    vscode = true,
  },
}
