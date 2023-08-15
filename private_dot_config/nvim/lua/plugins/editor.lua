local g = vim.g

return {
  {
    "ja-ford/delaytrain.nvim",
    keys = {
      "<Down>",
      "<Left>",
      "<Right>",
      "<Up>",
      "h",
      "j",
      "k",
      "l",
    },
    opts = {
      grace_period = 2,
      ignore_filetypes = { "neo%-tree", "qf" },
    },
  },
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
    "ggandor/leap.nvim",
    keys = {
      { "X", mode = { "n", "x", "o" }, desc = "Leap backward before" },
      { "x", mode = { "n", "x", "o" }, desc = "Leap forward before" },
    },
    config = function()
      require("leap").add_default_mappings(true)
    end,
  },
  {
    "chentoast/marks.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      sign_priority = 13,
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
    opts = function()
      return {
        on_substitute = require("yanky.integration").substitute(),
      }
    end,
    event = { "BufNewFile", "BufReadPost" },
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
      g.VM_maps = {
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
    "gbprod/yanky.nvim",
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
}
