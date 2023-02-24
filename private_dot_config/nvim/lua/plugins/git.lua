local api = vim.api

return {
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
    "tpope/vim-fugitive",
    cmd = { "G", "Gclog" },
  },
}
