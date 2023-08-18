return {
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  {
    "max397574/better-escape.nvim",
    config = true,
    event = "InsertEnter",
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
    opts = function()
      local cwd = vim.loop.cwd()
      local homedir = vim.loop.os_homedir()
      local goneovim_folder = homedir .. "\\scoop\\apps\\goneovim\\current"
      local neovide_folder = (os.getenv("ProgramFiles") or "") .. "\\Neovide"

      return {
        auto_session_enable_last_session = cwd == goneovim_folder or cwd == homedir or cwd == neovide_folder,
        auto_session_suppress_dirs = { goneovim_folder, neovide_folder },
        log_level = vim.log.levels.ERROR,
        pre_save_cmds = {
          function()
            require("neo-tree.sources.manager").close_all()
          end,
        },
        session_lens = {
          previewer = true,
        },
      }
    end,
  },
  {
    "echasnovski/mini.bracketed",
    config = true,
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
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
          vim.g.sqlite_clib_path = os.getenv("ChocolateyInstall") .. "/lib/SQLite/tools/sqlite3.dll"
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
    opts = {
      defaults = {
        ["<leader>h"] = "+hunks",
        ["[<Space>"] = { "Add blank lines above", mode = "n" },
        ["[e"] = { "Exchange line with lines above", mode = { "n", "x" } },
        ["]<Space>"] = { "Add blank lines below", mode = "n" },
        ["]e"] = { "Exchange line with lines below", mode = { "n", "x" } },
      },
      operators = {
        ["<space>z"] = "Send to REPL",
      },
    },
  },
}
