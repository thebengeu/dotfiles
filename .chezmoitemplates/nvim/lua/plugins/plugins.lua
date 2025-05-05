local util = require("util")

local WSL_WINDOWS_HOMEDIR = "/mnt/c/Users/beng"

local cwd = vim.uv.cwd()
local homedir = vim.uv.os_homedir()
local auto_restore_last_session = cwd
  and (
    cwd:match("\\scoop\\apps\\")
    or cwd == vim.env.windir
    or cwd == "/"
    or cwd == homedir
  )
local path_sep = package.config:sub(1, 1)
local obsidian_vault_path = (
  vim.fn.isdirectory(WSL_WINDOWS_HOMEDIR) == 1 and WSL_WINDOWS_HOMEDIR
  or homedir
)
  .. path_sep
  .. "Obsidian"

local autosave_and_restore = function(path, fallback_to_cd)
  if not path then
    return false
  end

  local AutoSession = require("auto-session")
  local Config = require("auto-session.config")

  AutoSession.AutoSaveSession()
  util.set_virtual_lines(false)

  local session_restored =
    AutoSession.RestoreSession(path, { show_message = false })

  if not session_restored and fallback_to_cd then
    Config.auto_save = false
    Snacks.bufdelete.all()
    vim.cmd.cd(path)
    Config.auto_save = true
  end

  util.set_virtual_lines(true)

  return session_restored
end

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
      {
        "<leader>ql",
        function()
          local Config = require("auto-session.config")
          local Lib = require("auto-session.lib")

          local alternate_session_name =
            Lib.get_alternate_session_name(Config.session_lens.session_control)

          if not autosave_and_restore(alternate_session_name) then
            vim.cmd.SessionSearch()
          end
        end,
        desc = "Alternate Session",
      },
      { "<leader>qo", "<cmd>SessionSearch<cr>", desc = "Sessions" },
      unpack(vim
        .iter({
          a = "~/supabase/supabase-admin-api",
          b = "~/sb",
          c = "~/.local/share/chezmoi",
          e = "~/supabase/data-engineering",
          f = "~/thebengeu/qmk_firmware",
          g = "~/thebengeu",
          h = "~/supabase/helper-scripts",
          i = "~/supabase/infrastructure",
          k = "~/thebengeu/drakon",
          p = "~/supabase/postgres",
          r = "~/repos",
          s = "~/supabase",
          u = "~/thebengeu/qmk_userspace",
          w = "~/supabase/supabase",
          x = "~/supabase/infrastructure-external",
          z = "~/thebengeu/zmk-config",
        })
        :map(function(key, path)
          local get_directory = key == "g" or key == "r" or key == "s"

          return {
            "<leader>q" .. key,
            get_directory
                and util.get_directory(function(selected_path)
                  autosave_and_restore(selected_path, true)
                end, vim.fn.expand(path))
              or function()
                autosave_and_restore(vim.fn.expand(path), true)
              end,
            desc = path:match("[^/]+$")
              .. (get_directory and " subdirectory" or ""),
          }
        end)
        :totable()),
    },
    lazy = false,
    opts = {
      allowed_dirs = {
        "~/.local/share/chezmoi",
        "~/repos/*",
        "~/sb",
        "~/supabase/*",
        "~/thebengeu/*",
      },
      auto_restore_last_session = auto_restore_last_session,
      continue_restore_on_error = true,
      cwd_change_handling = true,
      log_level = "error",
      lsp_stop_on_restore = true,
      no_restore_cmds = auto_restore_last_session and {
        "cd ~/.local/share/chezmoi",
      } or nil,
      session_lens = {
        load_on_setup = false,
        previewer = true,
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      require("copilot.api").status = require("copilot.status")
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "luarocks install tiktoken_core",
  },
  {
    "direnv/direnv.vim",
    cond = cwd and cwd:match("thebengeu") ~= nil,
    config = function()
      vim.g.direnv_silent_load = 1
    end,
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
    "echasnovski/mini.pairs",
    enabled = false,
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
    "subnut/nvim-ghost.nvim",
    cond = not not vim.g.neovide,
    priority = 1001,
  },
  {
    "obsidian-nvim/obsidian.nvim",
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
    lazy = vim.env.WEZTERM_UNIX_SOCKET ~= nil,
  },
  {
    "folke/snacks.nvim",
    init = function()
      local mini_icons_hl = vim
        .iter(util.rainbow_colors)
        :map(function(rainbow_color)
          return "MiniIcons" .. rainbow_color:gsub("Violet", "Purple")
        end)
        :totable()

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
            or rainbow_hl_if_exists(mini_icons_hl)

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
            winblend = 10,
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
    opts = function(_, opts)
      opts.icons = { mappings = false }
      opts.spec[1] = util.filter(opts.spec[1], function(spec)
        if spec[1] == "<leader>gh" then
          spec[1] = "<leader>h"
        end

        return spec[1] ~= "gx"
      end)
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    keys = {
      {
        "<leader>fy",
        "<cmd>Yazi<cr>",
        desc = "Open Yazi (Directory of Current File)",
      },
      {
        "<leader>fY",
        "<cmd>Yazi cwd<cr>",
        desc = "Open Yazi (cwd)",
      },
    },
    opts = {
      yazi_floating_window_winblend = 10,
    },
  },
}
