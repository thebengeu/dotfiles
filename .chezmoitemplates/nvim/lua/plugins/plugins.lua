local Util = require("lazyvim.util")

return {
  {
    "max397574/better-escape.nvim",
    config = true,
    enabled = vim.fn.hostname():lower():match("minibook") ~= nil,
    event = "InsertEnter",
  },
  {
    "rmagatti/auto-session",
    keys = {
      {
        "<leader>qd",
        "<Cmd>Autosession delete<CR>",
        desc = "Delete Session",
      },
      {
        "<leader>ql",
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
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local filetype = vim.bo[buf].filetype
              if filetype == "" or filetype == "noice" or filetype == "qf" then
                vim.api.nvim_win_close(win, true)
              end
            end
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
    "direnv/direnv.vim",
    cond = vim.loop.cwd():match("thebengeu") ~= nil,
    config = function()
      vim.g.direnv_silent_load = 1
    end,
  },
  {
    "echasnovski/mini.bracketed",
    config = true,
    event = "LazyFile",
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
      {
        "<leader>e",
        "<leader>fe",
        desc = "Explorer NeoTree (cwd)",
        remap = true,
      },
      {
        "<leader>E",
        "<leader>fE",
        desc = "Explorer NeoTree (root dir)",
        remap = true,
      },
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
    event = "VeryLazy",
    opts = {
      deleteBufferWhenFileDeleted = true,
    },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
        mode = "n",
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        mode = "n",
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        mode = "n",
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        mode = "n",
      },
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = "n",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = "n",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = "n",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = "n",
      },
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
        mode = "t",
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        mode = "t",
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        mode = "t",
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        mode = "t",
      },
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = "t",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = "t",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = "t",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = "t",
      },
    },
  },
  {
    "kkharji/sqlite.lua",
    config = function()
      if jit.os == "Windows" then
        vim.g.sqlite_clib_path = vim.env.ChocolateyInstall
          .. "/lib/SQLite/tools/sqlite3.dll"
      end
    end,
    enabled = true,
    lazy = true,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = "<C-/>",
    opts = {
      open_mapping = "<C-/>",
      persist_mode = false,
      shell = "fish",
    },
  },
  {
    "dstein64/vim-startuptime",
    enabled = false,
  },
  {
    "wakatime/vim-wakatime",
    event = "LazyFile",
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>h"] = "+hunks",
      },
      operators = {
        ["<leader>cz"] = "Send to REPL",
      },
    },
  },
}
