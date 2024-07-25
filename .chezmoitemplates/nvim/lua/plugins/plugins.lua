local LazyVim = require("lazyvim.util")

local WSL_WINDOWS_HOMEDIR = "/mnt/c/Users/beng"

local path_sep = package.config:sub(1, 1)
local obsidian_vault_path = (
  vim.fn.isdirectory(WSL_WINDOWS_HOMEDIR) == 1 and WSL_WINDOWS_HOMEDIR
  or vim.loop.os_homedir()
)
  .. path_sep
  .. "Obsidian"

return {
  {
    "rmagatti/auto-session",
    keys = {
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
      local windir = vim.env.windir

      return {
        ---@diagnostic disable-next-line: need-check-nil
        auto_session_enable_last_session = cwd:match("\\scoop\\apps\\")
          or cwd == homedir
          or cwd == windir
          or cwd == "/",
        auto_session_use_git_branch = true,
        cwd_change_handling = {
          restore_upcoming_session = true,
        },
        log_level = vim.log.levels.ERROR,
        pre_save_cmds = {
          function()
            require("neo-tree.sources.manager").close_all()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local filetype = vim.bo[buf].filetype
              if
                filetype == "blame"
                or filetype == "noice"
                or filetype == "qf"
                or filetype == "spectre_panel"
              then
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
    "max397574/better-escape.nvim",
    enabled = vim.fn.hostname():lower():match("minibook") ~= nil,
    event = "InsertEnter",
    opts = {},
  },
  {
    "direnv/direnv.vim",
    cond = vim.loop.cwd():match("thebengeu") ~= nil,
    config = function()
      vim.g.direnv_silent_load = 1
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>h", false },
      {
        "<leader>m",
        function()
          require("telescope").extensions.harpoon.marks()
        end,
        desc = "Harpoon Marks",
      },
    },
    url = "https://github.com/thebengeu/harpoon.git",
  },
  {
    "ramilito/kubectl.nvim",
    keys = {
      {
        "<leader>ck",
        function()
          require("kubectl").open()
        end,
        desc = "Kubectl",
      },
    },
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    event = "LazyFile",
    opts = {},
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
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
      sources = { "filesystem" },
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      minimumBufferNum = 5,
      retirementAgeMins = 60,
    },
  },
  {
    "epwalsh/obsidian.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufReadPre **/Obsidian/**.md",
    keys = {
      { "<leader>fv", "<Cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian" },
      { "<leader>sv", "<Cmd>ObsidianSearch<CR>", desc = "Obsidian" },
    },
    opts = {
      workspaces = {
        {
          name = "Obsidian",
          path = obsidian_vault_path,
        },
      },
    },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
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
    vscode = true,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<C-/>",
        function()
          require("toggleterm").toggle(vim.v.count1, nil, LazyVim.root())
        end,
      },
    },
    opts = {
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
      icons = {
        mappings = false,
      },
      spec = {
        { "<leader>cz", desc = "Send to REPL" },
        { "<leader>h", group = "hunks" },
      },
    },
  },
}
