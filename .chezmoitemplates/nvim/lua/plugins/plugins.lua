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
      { "<leader>ql", "<cmd>SessionSearch<cr>", desc = "List Sessions" },
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
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "luarocks install tiktoken_core",
  },
  {
    "direnv/direnv.vim",
    cond = vim.uv.cwd():match("thebengeu") ~= nil,
    config = function()
      vim.g.direnv_silent_load = 1
    end,
  },
  {
    "chrishrb/gx.nvim",
    keys = {
      { "gX", "<cmd>Browse<cr>", desc = "Browse", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    "chentoast/marks.nvim",
    event = "LazyFile",
    opts = {
      sign_priority = 13,
    },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = {
        "TelescopePrompt",
        "snacks_picker_input",
        "snacks_picker_list",
      },
      map_c_h = true,
      map_c_w = true,
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = "junegunn/fzf",
    ft = "qf",
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
    "kevinhwang91/nvim-fundo",
    dependencies = "kevinhwang91/promise-async",
    event = "LazyFile",
    make = function()
      require("fundo").install()
    end,
    opts = {},
  },
  {
    "epwalsh/obsidian.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufReadPre **/Obsidian/**.md",
    keys = {
      { "<leader>fo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian" },
      { "<leader>so", "<cmd>ObsidianSearch<cr>", desc = "Obsidian" },
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
    init = function()
      local ts_rainbow_2_hl = vim
        .iter(util.rainbow_colors)
        :map(function(rainbow_color)
          return "TSRainbow" .. rainbow_color
        end)
        :totable()

      local ts_rainbow_hl = {}

      for i = 1, 7 do
        table.insert(ts_rainbow_hl, "rainbowcol" .. i)
      end

      local hl_not_exists = function(hl_name)
        local hl = vim.api.nvim_get_hl(0, { name = hl_name })
        return next(hl) == nil or hl.default
      end

      local rainbow_hl_if_exists = function(rainbow_hl)
        for i = 1, 7 do
          if hl_not_exists(rainbow_hl[i]) then
            return false
          end
        end

        return rainbow_hl
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          util.set_highlights()

          local rainbow_hl = rainbow_hl_if_exists(util.rainbow_delimiters_hl)
            or rainbow_hl_if_exists(ts_rainbow_2_hl)
            or rainbow_hl_if_exists(ts_rainbow_hl)

          if not rainbow_hl then
            error("No rainbow highlight groups found")
          end

          for i, hl_name in ipairs(rainbow_hl) do
            vim.api.nvim_set_hl(0, util.rainbow_delimiters_hl[i], {
              fg = vim.api.nvim_get_hl(0, { link = false, name = hl_name }).fg,
            })
          end

          for _, hl_suffix in ipairs({ "Dir", "PathHidden", "PathIgnored" }) do
            local hl_name = "SnacksPicker" .. hl_suffix
            if hl_not_exists(hl_name) then
              local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
              local hl = vim.tbl_extend("force", comment_hl, { italic = false })

              vim.api.nvim_set_hl(0, hl_name, hl)
            end
          end
        end,
      })
    end,
    opts = {
      dashboard = {
        enabled = false,
      },
      indent = {
        indent = {
          hl = util.rainbow_delimiters_hl,
        },
        scope = {
          char = "┃",
          underline = true,
          hl = util.rainbow_delimiters_hl,
        },
      },
      styles = {
        lazygit = {
          wo = {
            winblend = 0,
          },
        },
      },
    },
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertCharPre",
    opts = {
      act_as_shift_tab = true,
    },
  },
  { "wakatime/vim-wakatime" },
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      opts.spec[1] = util.filter(opts.spec[1], function(spec)
        return spec[1] ~= "<leader>gh" and spec[1] ~= "gx"
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
