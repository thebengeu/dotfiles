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
    keys = {
      {
        "<space>sl",
        function()
          require("auto-session.session-lens").search_session()
        end,
        desc = "Sessions",
      },
    },
    lazy = false,
    opts = {
      auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir() .. "\\scoop\\apps\\goneovim\\current"
        or vim.loop.cwd() == "C:\\Program Files\\Neovide"
        or vim.loop.cwd() == vim.loop.os_homedir(),
      log_level = vim.log.levels.ERROR,
      pre_save_cmds = {
        require("neo-tree.sources.manager").close_all,
      },
      session_lens = {
        previewer = true,
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
    "danielfalk/smart-open.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      config = function()
        if jit.os:find("Windows") then
          vim.g.sqlite_clib_path = "C:/ProgramData/chocolatey/lib/SQLite/tools/sqlite3.dll"
        end
      end,
      enabled = true,
    },
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
    config = true,
    keys = {
      { "<A-j>", mode = { "i", "n", "v" } },
      { "<A-k>", mode = { "i", "n", "v" } },
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
