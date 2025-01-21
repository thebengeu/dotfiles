local util = require("util")

local WSL_WINDOWS_HOMEDIR = "/mnt/c/Users/beng"

local cwd = vim.uv.cwd()
local homedir = vim.uv.os_homedir()
local path_sep = package.config:sub(1, 1)
local obsidian_vault_path = (
  vim.fn.isdirectory(WSL_WINDOWS_HOMEDIR) == 1 and WSL_WINDOWS_HOMEDIR
  or homedir
)
  .. path_sep
  .. "Obsidian"

return {
  {
    "otavioschwanck/arrow.nvim",
    dependencies = "echasnovski/mini.icons",
    keys = { "," },
    opts = {
      index_keys = "asdfjkl'",
      leader_key = ",",
      mappings = {
        delete_mode = "D",
        toggle = "S",
      },
      show_icons = true,
    },
  },
  {
    "rmagatti/auto-session",
    keys = {
      { "<leader>ql", "<Cmd>SessionSearch<CR>", desc = "List Sessions" },
    },
    lazy = false,
    opts = {
      ---@diagnostic disable-next-line: need-check-nil
      auto_restore_last_session = cwd:match("\\scoop\\apps\\")
        or cwd == vim.env.windir
        or cwd == "/",
      continue_restore_on_error = true,
      cwd_change_handling = true,
      log_level = "error",
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
    },
  },
  {
    "max397574/better-escape.nvim",
    enabled = vim.fn.hostname():lower():match("minibook") ~= nil,
    event = "InsertEnter",
    opts = {},
  },
  {
    "direnv/direnv.vim",
    cond = vim.uv.cwd():match("thebengeu") ~= nil,
    config = function()
      vim.g.direnv_silent_load = 1
    end,
  },
  {
    "robitx/gp.nvim",
    keys = {
      { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
      { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
      { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
      { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
      { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
      { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
      { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
      { "<C-g>g", group = "generate into new .." },
      { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
      { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
      { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
      { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
      { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
      { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
      { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
      { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
      { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
      { "<C-g>w", group = "Whisper" },
      {
        "<C-g>wa",
        "<cmd>GpWhisperAppend<cr>",
        desc = "Whisper Append (after)",
      },
      {
        "<C-g>wb",
        "<cmd>GpWhisperPrepend<cr>",
        desc = "Whisper Prepend (before)",
      },
      { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
      { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
      { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
      {
        "<C-g>wr",
        "<cmd>GpWhisperRewrite<cr>",
        desc = "Whisper Inline Rewrite",
      },
      { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
      { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
      { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
      { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
    },
    opts = {},
  },
  {
    "chrishrb/gx.nvim",
    keys = {
      { "gX", "<Cmd>Browse<CR>", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    "ramilito/kubectl.nvim",
    cmd = "Kubectx",
    keys = {
      {
        "<leader>ck",
        function()
          require("kubectl").toggle()
        end,
        desc = "Kubectl",
      },
    },
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    event = "LazyFile",
    keys = {
      { "[d" },
      { "]d" },
    },
    opts = {
      buffer = { suffix = "" },
      comment = { suffix = "" },
      conflict = { suffix = "" },
      file = { suffix = "g" },
      window = { suffix = "" },
      yank = { suffix = "" },
    },
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
    "stevearc/oil.nvim",
    dependencies = "echasnovski/mini.icons",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
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
      {
        "<C-\\>",
        function()
          require("smart-splits").move_cursor_previous()
        end,
      },
    },
    lazy = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
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
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  { "wakatime/vim-wakatime" },
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      opts.spec[1] = util.filter(opts.spec[1], function(spec)
        return spec[1] ~= "<leader>gh"
      end)
      require("which-key").setup(opts)
    end,
    opts = {
      icons = {
        mappings = false,
      },
      spec = {
        { "<leader>cz", desc = "Send to REPL" },
        { "<leader>h", group = "hunks", mode = { "n", "x" } },
      },
    },
  },
}
