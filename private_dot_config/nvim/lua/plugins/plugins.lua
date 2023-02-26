local api = vim.api
local g = vim.g

return {
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  { "rmagatti/auto-session" },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSHighlightCapturesUnderCursor",
      "TSPlaygroundToggle",
    },
  },
  {
    "rmagatti/session-lens",
    keys = {
      {
        "<space>sl",
        function()
          require("session-lens").search_session()
        end,
        desc = "Sessions",
      },
    },
  },
  {
    "danielfalk/smart-open.nvim",
    dependencies = "kkharji/sqlite.lua",
    keys = {
      {
        "<leader><space>",
        function()
          require("telescope").extensions.smart_open.smart_open()
        end,
        desc = "Smart Open",
      },
    },
  },
  {
    "aserowy/tmux.nvim",
    keys = {
      "<C-h>",
      "<C-j>",
      "<C-k>",
      "<C-l>",
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        mode = "t",
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
        mode = "t",
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
        mode = "t",
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        mode = "t",
      },
    },
    opts = {
      resize = {
        enable_default_keybindings = false,
      },
    },
  },
  {
    "tpope/vim-unimpaired",
    config = function()
      local register = require("which-key").register

      for _, key in ipairs({
        "<C-L>",
        "<C-Q>",
        "<C-T>",
        "A",
        "a",
        "B",
        "C",
        "f",
        "L",
        "l",
        "n",
        "o",
        "P",
        "T",
        "u",
        "x",
        "y",
      }) do
        register({
          ["[" .. key] = "which_key_ignore",
          ["]" .. key] = "which_key_ignore",
        })
      end
    end,
    keys = {
      { "[<space>", desc = "Add blank lines above" },
      { "]<space>", desc = "Add blank lines below" },
      { "[p", desc = "Paste before linewise" },
      { "]p", desc = "Paste after linewise" },
      { "[q", desc = "Previous item in quickfix list" },
      { "]q", desc = "Next item in quickfix list" },
      { "[Q", desc = "First item in quickfix list" },
      { "]Q", desc = "Last item in quickfix list" },
    },
  },
  {
    "wakatime/vim-wakatime",
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "folke/which-key.nvim",
    config = function(plugin, opts)
      local super = plugin._.super
      super.config(super, opts)

      require("which-key").register({
        ["<leader>d"] = { name = "+debug" },
        ["<leader>gh"] = "which_key_ignore",
      })
    end,
  },
}
