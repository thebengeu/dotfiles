local api = vim.api
local g = vim.g

return {
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  { "rmagatti/auto-session" },
  {
    "chentoast/marks.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      sign_priority = 13,
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        should_preview_cb = function(bufnr, qwinid)
          local bufname = api.nvim_buf_get_name(bufnr)
          if bufname:match("^fugitive://") and not api.nvim_buf_is_loaded(bufnr) then
            if Bqf_preview_timer and Bqf_preview_timer:get_due_in() > 0 then
              Bqf_preview_timer:stop()
              Bqf_preview_timer = nil
            end
            Bqf_preview_timer = vim.defer_fn(function()
              api.nvim_buf_call(bufnr, function()
                vim.cmd(("do fugitive BufReadCmd %s"):format(bufname))
              end)
              require("bqf.preview.handler").open(qwinid, nil, true)
            end, 60)
          end
          return true
        end,
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
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git", "pyproject.toml" },
      })
    end,
    event = "BufEnter",
    keys = {
      {
        "<leader>p",
        function()
          require("telescope").extensions.projects.projects()
        end,
        desc = "Projects",
      },
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
