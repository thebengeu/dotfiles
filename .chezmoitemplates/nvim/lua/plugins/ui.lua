local util = require("util")

return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        offsets = {},
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = "nvim-telescope/telescope-fzf-native.nvim",
    event = "LazyFile",
  },
  {
    "folke/edgy.nvim",
    opts = {
      animate = { enabled = false },
      keys = {
        ["<A-h>"] = function(win)
          win:resize(
            "width",
            require("edgy").get_win().view.edgebar.pos == "right" and 2 or -2
          )
        end,
        ["<A-j>"] = function(win)
          win:resize("height", -2)
        end,
        ["<A-k>"] = function(win)
          win:resize("height", 2)
        end,
        ["<A-l>"] = function(win)
          win:resize(
            "width",
            require("edgy").get_win().view.edgebar.pos == "right" and -2 or 2
          )
        end,
      },
    },
  },
  {
    "jinh0/eyeliner.nvim",
    config = function(_, opts)
      require("eyeliner").setup(opts)

      local add_bold_and_underline = function(name)
        vim.api.nvim_set_hl(0, name, {
          bold = true,
          fg = vim.api.nvim_get_hl(0, { name = name }).fg,
          underline = true,
        })
      end

      local callback = function()
        add_bold_and_underline("EyelinerPrimary")
        add_bold_and_underline("EyelinerSecondary")
      end

      callback()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = callback,
      })
    end,
    event = "LazyFile",
    opts = {
      disabled_filetypes = {
        "dropbar_menu",
        "help",
        "neo-tree",
        "qf",
        "trouble",
      },
    },
    vscode = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function(_, opts)
      local hooks = require("ibl.hooks")

      local ts_rainbow_2_hl = util.map(
        util.rainbow_colors,
        function(rainbow_color)
          return "TSRainbow" .. rainbow_color
        end
      )

      local ts_rainbow_hl = {}

      for i = 1, 7 do
        table.insert(ts_rainbow_hl, "rainbowcol" .. i)
      end

      local rainbow_hl_if_exists = function(rainbow_hl)
        for i = 1, 7 do
          local hl = vim.api.nvim_get_hl(0, { name = rainbow_hl[i] })

          if next(hl) == nil or hl.default then
            return false
          end
        end

        return rainbow_hl
      end

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        local get_highlights = util.highlights[vim.g.colors_name]

        if get_highlights then
          for name, highlight in pairs(get_highlights()) do
            vim.api.nvim_set_hl(0, name, highlight)
          end
        end

        local rainbow_hl = rainbow_hl_if_exists(util.rainbow_delimiters_hl)
          or rainbow_hl_if_exists(ts_rainbow_2_hl)
          or rainbow_hl_if_exists(ts_rainbow_hl)

        if not rainbow_hl then
          error("No rainbow highlight groups found")
        end

        for i, hl_name in ipairs(rainbow_hl) do
          vim.api.nvim_set_hl(
            0,
            util.rainbow_delimiters_hl[i],
            { fg = vim.api.nvim_get_hl(0, { link = false, name = hl_name }).fg }
          )
        end
      end)

      require("ibl").setup(opts)
    end,
    opts = {
      indent = {
        highlight = util.rainbow_delimiters_hl,
      },
      scope = {
        char = "┃",
        enabled = true,
        exclude = {
          language = { "yaml" },
        },
        highlight = util.rainbow_delimiters_hl,
        show_start = true,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            any = {
              { find = "%d+ change" },
              { find = "%d+L, %d+B" },
              { kind = "search_count" },
            },
          },
          opts = {
            skip = true,
          },
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = util.map({ "n", "N", "*", "#", "g*", "g#" }, function(key)
      return {
        key,
        function()
          vim.cmd.normal({
            ((key == "n" or key == "N") and vim.v.count1 or "") .. key,
            bang = true,
          })
          require("hlslens").start()
        end,
      }
    end),
    opts = {
      calm_down = true,
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
  },
  {
    "lewis6991/satellite.nvim",
    event = "LazyFile",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").add({
          { "<LeftMouse>", hidden = true, mode = { "i", "n", "o", "x" } },
        })
      end)
    end,
    opts = {},
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      legacy_computing_symbols_support = true,
    },
    version = "^0.3.2",
  },
}
