local map = require("util").map

return {
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")

      vim.list_extend(require("dial.config").augends.group.default, {
        augend.constant.alias.bool,
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "and", "or" } }),
      })
    end,
    keys = {
      {
        "<C-a>",
        "<Plug>(dial-increment)",
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
      },
      {
        "<C-a>",
        "<Plug>(dial-increment)",
        { mode = "v" },
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
        { mode = "v" },
      },
      {
        "g<C-a>",
        "g<Plug>(dial-increment)",
        { mode = "v" },
      },
      {
        "g<C-x>",
        "g<Plug>(dial-decrement)",
        { mode = "v" },
      },
    },
  },
  {
    "folke/flash.nvim",
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
    keys = vim.list_extend(
      {
        { "<M-h>", mode = "v" },
        { "<M-j>", mode = "v" },
        { "<M-k>", mode = "v" },
        { "<M-l>", mode = "v" },
        { "<S-Down>" },
        { "<S-Left>" },
        { "<S-Right>" },
        { "<S-Up>" },
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
      },
      map({
        h = "left",
        j = "down",
        k = "up",
        l = "right",
      }, function(direction, key)
        return {
          "<M-" .. key .. ">",
          function()
            require("mini.move").move_line(direction)
          end,
          desc = "Move line " .. direction,
          mode = "i",
        }
      end)
    ),
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
    "chrisgrieser/nvim-spider",
    keys = map({ "b", "e", "ge", "w" }, function(key)
      return {
        key,
        "<Cmd>lua require('spider').motion('" .. key .. "')<CR>",
        mode = { "n", "o", "x" },
      }
    end),
  },
  {
    "ojroques/nvim-osc52",
    cond = function()
      if vim.env.TITLE_PREFIX == "wsl:" then
        vim.env.PATH = vim.env.PATH
          .. ":/mnt/c/Users/"
          .. vim.env.USER
          .. "/scoop/shims"
        return false
      end

      if not vim.env.SSH_CONNECTION then
        return false
      end

      local tmux = vim.env.TMUX

      vim.system({ "lmn", "paste" }, nil, function(system_obj)
        if system_obj.code == 0 then
          vim.g.clipboard = {
            cache_enabled = 1,
            copy = {
              ["*"] = { "lmn", "copy" },
              ["+"] = { "lmn", "copy" },
            },
            name = "lemonade",
            paste = {
              ["*"] = { "lmn", "paste" },
              ["+"] = { "lmn", "paste" },
            },
          }
        elseif not tmux then
          vim.schedule(function()
            vim.opt.clipboard = ""

            vim.api.nvim_create_autocmd("TextYankPost", {
              callback = function()
                if
                  vim.v.event.operator == "y" and vim.v.event.regname == ""
                then
                  require("osc52").copy_register("")
                end
              end,
            })
          end)
        end
      end)

      return not tmux
    end,
    lazy = true,
    opts = {
      silent = true,
    },
  },
  {
    "linty-org/readline.nvim",
    keys = {
      {
        "<C-a>",
        function()
          require("readline").dwim_beginning_of_line()
        end,
        mode = "!",
      },
      {
        "<C-e>",
        function()
          require("readline").end_of_line()
        end,
        mode = "!",
      },
      {
        "<C-u>",
        function()
          require("readline").dwim_backward_kill_line()
        end,
        mode = "!",
      },
      {
        "<C-w>",
        function()
          require("readline").unix_word_rubout()
        end,
        mode = "!",
      },
      {
        "<M-BS>",
        function()
          require("readline").backward_kill_word()
        end,
        mode = "!",
      },
      {
        "<M-b>",
        function()
          require("readline").backward_word()
        end,
        mode = "!",
      },
      {
        "<M-d>",
        function()
          require("readline").kill_word()
        end,
        mode = "!",
      },
      {
        "<M-f>",
        function()
          require("readline").forward_word()
        end,
        mode = "!",
      },
    },
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
    config = true,
    keys = {
      { "ga", desc = "+text-case" },
    },
  },
  {
    "cappyzawa/trim.nvim",
    config = true,
    event = "BufWritePre",
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
    "svban/YankAssassin.vim",
    event = "LazyFile",
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "y", false, mode = { "n", "x" } },
    },
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
}
