local api = vim.api
local g = vim.g

return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  { "rmagatti/auto-session" },
  { "alker0/chezmoi.vim" },
  {
    "akinsho/git-conflict.nvim",
    config = true,
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
        local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

        map("n", "]h", next_hunk_repeat, "Next Hunk")
        map("n", "[h", prev_hunk_repeat, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

        require("which-key").register({
          ["<leader>h"] = "+hunks",
        })

        api.nvim_buf_attach(buffer, false, {
          on_detach = function()
            require("which-key").register({
              ["<leader>h"] = "which_key_ignore",
            })
          end,
        })
      end,
    },
  },
  {
    "DNLHC/glance.nvim",
    keys = {
      { "gd", "<Cmd>Glance definitions<cr>", desc = "Goto Definition" },
      { "gI", "<Cmd>Glance implementations<cr>", desc = "Goto Implementation" },
      { "gr", "<Cmd>Glance references<cr>", desc = "References" },
      { "gt", "<Cmd>Glance type_definitions<cr>", desc = "Goto Type Definition" },
    },
    opts = {
      hooks = {
        before_open = function(results, open, jump)
          if #results == 1 then
            jump()
          else
            open()
          end
        end,
      },
    },
  },
  {
    "/hkupty/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          repl_definition = {
            python = require("iron.fts.python").ipython,
          },
          repl_open_cmd = require("iron.view").split.horizontal.botright(20, {
            number = false,
            relativenumber = false,
          }),
        },
        keymaps = {
          send_motion = "<space>z",
          visual_send = "<C-z>",
        },
      })
    end,
    keys = {
      { "<C-z>", mode = "v" },
      {
        "<C-z>",
        function()
          local mark_rows = {}

          for char in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
            local mark = api.nvim_buf_get_mark(0, char)
            local mark_row = mark[1]
            if mark_row ~= 0 then
              table.insert(mark_rows, mark_row)
            end
          end

          table.sort(mark_rows)

          local cursor = api.nvim_win_get_cursor(0)
          local current_row = cursor[1]
          local start_row = 1
          local end_row = api.nvim_buf_line_count(0)

          for _, mark_row in ipairs(mark_rows) do
            if mark_row <= current_row then
              start_row = mark_row
            else
              end_row = mark_row - 1
              break
            end
          end

          api.nvim_win_set_cursor(0, { start_row, 0 })
          vim.cmd("normal V")
          api.nvim_win_set_cursor(0, { end_row, 0 })
          require("iron.core").visual_send()
          api.nvim_win_set_cursor(0, cursor)
        end,
      },
      { "<space>r", "<Cmd>IronRepl<CR>", desc = "REPL" },
      { "<space>z", desc = "Send to REPL" },
    },
  },
  {
    "GCBallesteros/jupytext.vim",
    config = function()
      g.jupytext_fmt = "py"
      g.jupytext_style = ":hydrogen"
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
    "vuki656/package-info.nvim",
    config = true,
    ft = "json",
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
    "blankname/vim-fish",
    ft = "fish",
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Gclog" },
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
