local util = require("util")

return {
  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<leader>gM", "<cmd>BlameToggle<cr>", desc = "Blame" },
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
        "<leader>gH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Diffview History",
      },
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Diffview File History",
      },
      {
        "<leader>gh",
        ":DiffviewFileHistory<cr>",
        desc = "Diffview Range History",
        mode = "x",
      },
      {
        "<leader>gV",
        "<cmd>DiffviewFileHistory --walk-reflogs --range=stash<cr>",
        desc = "Diffview Stash",
      },
      {
        "<leader>gv",
        "<cmd>DiffviewOpen<cr>",
        desc = "Diffview",
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
    "SuperBo/fugit2.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "chrisgrieser/nvim-tinygit",
      "nvim-lua/plenary.nvim",
    },
    enabled = jit.os ~= "Windows",
    keys = {
      { "<leader>gF", "<cmd>Fugit2<cr>", desc = "Fugit2" },
    },
    opts = {
      libgit2_path = jit.os == "OSX" and "/opt/homebrew/lib/libgit2.dylib"
        or nil,
    },
  },
  {
    "ldelossa/gh.nvim",
    cmd = "GHOpenPR",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        main = "litee.lib",
        opts = {},
      },
    },
    main = "litee.gh",
    opts = {},
  },
  {
    "linrongbin16/gitlinker.nvim",
    opts = {
      router = {
        browse = {
          ["^github%.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
        },
      },
    },
    keys = function()
      local link_using_default_branch = function(action)
        return function()
          local current_branch = util.git_stdout({ "branch", "--show-current" })

          util.git_stdout({ "sw" })
          require("gitlinker").link({
            action = require("gitlinker.actions")[action],
          })
          util.git_stdout({ "sw", current_branch })
        end
      end

      return {
        {
          "<leader>gk",
          link_using_default_branch("system"),
          mode = { "n", "x" },
          desc = "Open permalink (default branch)",
        },
        {
          "<leader>gK",
          "<cmd>GitLink!<cr>",
          mode = { "n", "x" },
          desc = "Open permalink (current branch)",
        },
        {
          "<leader>gy",
          link_using_default_branch("clipboard"),
          mode = { "n", "x" },
          desc = "Yank permalink (default branch)",
        },
        {
          "<leader>gY",
          "<cmd>GitLink<cr>",
          mode = { "n", "x" },
          desc = "Yank permalink (current branch)",
        },
      }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "LazyFile",
    opts = {},
  },
  {
    "moyiz/git-dev.nvim",
    cmd = {
      "GitDevCleanAll",
      "GitDevOpen",
      "GitDevRecents",
      "GitDevToggleUI",
    },
    opts = {
      cd_type = "tab",
      opener = function(dir, _, selected_path)
        vim.cmd("tabnew")
        vim.cmd("Neotree " .. dir)
        if selected_path then
          vim.cmd("edit " .. selected_path)
        end
      end,
    },
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

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function()
          gs.nav_hunk("last")
        end, "Last Hunk")
        map("n", "[H", function()
          gs.nav_hunk("first")
        end, "First Hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hB", function()
          gs.blame()
        end, "Blame Buffer")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map(
          { "o", "x" },
          "ih",
          ":<C-U>Gitsigns select_hunk<cr>",
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
        "<leader>go",
        "<cmd>lua MiniGit.show_at_cursor()<cr>",
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
      { "<leader>gn", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Neogit" },
    },
    opts = {},
  },
  {
    "chrisgrieser/nvim-tinygit",
    cmd = "Tinygit",
    dependencies = "stevearc/dressing.nvim",
  },
  {
    "pwntester/octo.nvim",
    keys = {
      { "<leader>gi", false },
      { "<leader>gI", false },
      { "<leader>gp", false },
      { "<leader>gP", false },
      { "<leader>gr", false },
      { "<leader>gS", false },
    },
    opts = {
      picker = "snacks",
    },
  },
  {
    "tanvirtin/vgit.nvim",
    cmd = "VGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      settings = {
        live_blame = {
          enabled = false,
        },
        live_gutter = {
          enabled = false,
        },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Gclog" },
  },
}
