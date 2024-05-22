local util = require("util")

return {
  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<leader>gB", "<Cmd>BlameToggle<CR>", desc = "Blame" },
    },
    opts = function()
      return {
        colors = util.map(util.rainbow_delimiters_hl, function(hl_name)
          return vim.api.nvim_get_hl(0, { link = false, name = hl_name }).fg
        end),
        date_format = "%Y-%m-%d",
        format_fn = require("blame.formats.default_formats").date_message,
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    keys = {
      {
        "<leader>gd",
        "<Cmd>DiffviewOpen<CR>",
        desc = "Diffview",
      },
      {
        "<leader>gH",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "Diffview History",
      },
      {
        "<leader>gh",
        "<Cmd>DiffviewFileHistory %<CR>",
        desc = "Diffview File History",
      },
      {
        "<leader>gh",
        ":DiffviewFileHistory<CR>",
        desc = "Diffview Range History",
        mode = "x",
      },
      {
        "<leader>gD",
        "<Cmd>DiffviewFileHistory --walk-reflogs --range=stash<CR>",
        desc = "Diffview Stash",
      },
    },
    opts = {
      enhanced_diff_hl = true,
      file_history_panel = {
        log_options = {
          git = {
            multi_file = {
              max_count = 1000,
            },
          },
        },
      },
      show_help_hints = false,
    },
  },
  {
    "akinsho/git-conflict.nvim",
    event = "LazyFile",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        local gs_visual = function(operation)
          return function()
            gs[operation](util.visual_lines())
          end
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map(
          { "o", "x" },
          "ih",
          ":<C-U>Gitsigns select_hunk<CR>",
          "GitSigns Select Hunk"
        )
        map("x", "<leader>hs", gs_visual("stage_hunk"), "Stage Hunk")
        map("x", "<leader>hr", gs_visual("reset_hunk"), "Reset Hunk")
        map("x", "<leader>hu", gs_visual("undo_stage_hunk"), "Undo Stage Hunk")
      end,
    },
  },
  {
    "echasnovski/mini-git",
    event = "LazyFile",
    keys = {
      {
        "<leader>gS",
        "<Cmd>lua MiniGit.show_at_cursor()<CR>",
        desc = "Show at cursor",
        mode = { "n", "x" },
      },
    },
    main = "mini.git",
    opts = {},
  },
  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gN", "<Cmd>Neogit cwd=%:p:h<CR>", desc = "Neogit" },
    },
    opts = {},
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
  },
  {
    "tpope/vim-rhubarb",
    dependencies = {
      "tpope/vim-fugitive",
      cmd = { "G", "Gclog" },
    },
    keys = {
      {
        "<leader>gl",
        "<Cmd>0GBrowse<CR>",
        desc = "Open Blob Permalink",
        mode = "n",
      },
      {
        "<leader>gl",
        ":GBrowse<CR>",
        desc = "Open Blob Permalink",
        mode = "x",
      },
    },
  },
}
