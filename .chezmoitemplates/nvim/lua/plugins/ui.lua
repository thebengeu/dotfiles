local util = require("util")

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "thebengeu/eyeliner.nvim",
    config = function()
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
    event = { "BufNewFile", "BufReadPre" },
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
        return vim.fn.hlexists(rainbow_hl[1]) == 1 and rainbow_hl
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
        highlight = util.rainbow_delimiters_hl,
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      vim.g.miniindentscope_disable = true
    end,
    opts = {
      options = {
        border = "top",
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
              { find = "%d+L, %d+B" },
              { kind = "search_count" },
            },
          },
          opts = {
            skip = true,
          },
        },
      },
      presets = {
        command_palette = false,
      },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    ft = "lua",
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
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "lewis6991/satellite.nvim",
    config = true,
    enabled = vim.version().minor >= 10,
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      setopt = true,
    },
  },
}
