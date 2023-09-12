local Util = require("lazyvim.util")
local toggle_term_open_mapping = (vim.g.goneovim or vim.g.neovide) and "<C-/>" or "<C-_>"

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
        "<space>qd",
        "<Cmd>Autosession delete<CR>",
        desc = "Delete Session",
      },
      {
        "<space>ql",
        function()
          require("auto-session").setup_session_lens()
          require("auto-session.session-lens").search_session()
        end,
        desc = "List Sessions",
      },
    },
    lazy = false,
    opts = function()
      local cwd = vim.loop.cwd()
      local homedir = vim.loop.os_homedir()
      local goneovim_folder = homedir .. "\\scoop\\apps\\goneovim\\current"
      local neovide_folder = (vim.env.ProgramFiles or "") .. "\\Neovide"
      local windir = vim.env.windir

      return {
        auto_session_enable_last_session = cwd == goneovim_folder
          or cwd == homedir
          or cwd == neovide_folder
          or cwd == windir,
        log_level = vim.log.levels.ERROR,
        pre_save_cmds = {
          function()
            require("neo-tree.sources.manager").close_all()
          end,
        },
        session_lens = {
          load_on_setup = false,
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
    keys = {
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = Util.get_root(),
          })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.loop.cwd(),
          })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_by_name = {
            "node_modules",
          },
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "thebengeu/smart-open.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      config = function()
        if jit.os:find("Windows") then
          vim.g.sqlite_clib_path = vim.env.ChocolateyInstall .. "/lib/SQLite/tools/sqlite3.dll"
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
    "mrjones2014/smart-splits.nvim",
    cond = vim.env.TMUX == nil,
    init = function()
      Util.on_very_lazy(function()
        require("smart-splits")
      end)
    end,
    keys = {
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
      },
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
      },
    },
  },
  {
    "aserowy/tmux.nvim",
    cond = vim.env.TMUX ~= nil,
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
    "akinsho/toggleterm.nvim",
    keys = toggle_term_open_mapping,
    opts = {
      open_mapping = toggle_term_open_mapping,
      shell = "fish",
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
      },
      operators = {
        ["<space>z"] = "Send to REPL",
      },
    },
  },
}
