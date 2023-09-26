local util = require("util")

return {
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gF",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "Diffview History",
      },
      {
        "<leader>gf",
        "<Cmd>DiffviewFileHistory %<CR>",
        desc = "Diffview File History",
      },
      {
        "<leader>gf",
        ":DiffviewFileHistory<CR>",
        desc = "Diffview Range History",
        mode = "x",
      },
      {
        "<leader>gS",
        "<Cmd>DiffviewFileHistory --walk-reflogs --range=stash<CR>",
        desc = "Diffview Stash",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
    event = { "BufNewFile", "BufReadPost" },
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
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
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
    "NeogitOrg/neogit",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gn", "<Cmd>Neogit<CR>", desc = "Neogit" },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Gclog" },
  },
}
