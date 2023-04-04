return {
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  {
    "max397574/better-escape.nvim",
    config = true,
  },
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      pre_save_cmds = {
        require("neo-tree.sources.manager").close_all,
      },
    },
  },
  {
    "echasnovski/mini.bracketed",
    config = function()
      require("mini.bracketed").setup()
    end,
    event = { "BufNewFile", "BufReadPost" },
  },
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
    opts = {
      operators = {
        ["<space>z"] = "Send to REPL",
      },
    },
  },
}
