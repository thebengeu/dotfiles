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
    config = function()
      require("substitute").setup({
        on_substitute = require("yanky.integration").substitute(),
      })
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
    "cappyzawa/trim.nvim",
    config = true,
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
    dependencies = "kkharji/sqlite.lua",
    keys = {
      {
        "p",
        "<Plug>(YankyPutAfter)",
        { mode = { "n", "x" } },
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        { mode = { "n", "x" } },
      },
      {
        "gp",
        "<Plug>(YankyGPutAfter)",
        { mode = { "n", "x" } },
      },
      {
        "gP",
        "<Plug>(YankyGPutBefore)",
        { mode = { "n", "x" } },
      },
      {
        "<C-n>",
        "<Plug>(YankyCycleForward)",
      },
      {
        "<C-p>",
        "<Plug>(YankyCycleBackward)",
      },
      {
        "<leader>sy",
        function()
          require("telescope").extensions.yank_history.yank_history()
        end,
        desc = "Yank History",
      },
      {
        "y",
        "<Plug>(YankyYank)",
        { mode = { "n", "x" } },
      },
      {
        "]p",
        "<Plug>(YankyPutIndentAfterLinewise)",
        desc = "Put after linewise",
      },
      {
        "[p",
        "<Plug>(YankyPutIndentBeforeLinewise)",
        desc = "Put before linewise",
      },
      {
        "]P",
        "<Plug>(YankyPutIndentAfterLinewise)",
        desc = "Put after linewise",
      },
      {
        "[P",
        "<Plug>(YankyPutIndentBeforeLinewise)",
        desc = "Put before linewise",
      },
      {
        ">p",
        "<Plug>(YankyPutIndentAfterShiftRight)",
        desc = "Put after linewise, +indent",
      },
      {
        "<p",
        "<Plug>(YankyPutIndentAfterShiftLeft)",
        desc = "Put after linewise, -indent",
      },
      {
        ">P",
        "<Plug>(YankyPutIndentBeforeShiftRight)",
        desc = "Put before linewise, +indent",
      },
      {
        "<P",
        "<Plug>(YankyPutIndentBeforeShiftLeft)",
        desc = "Put before linewise, -indent",
      },
      {
        "=p",
        "<Plug>(YankyPutAfterFilter)",
        desc = "Put after linewise, reindent",
      },
      {
        "=P",
        "<Plug>(YankyPutBeforeFilter)",
        desc = "Put before linewise, reindent",
      },
    },
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
}
