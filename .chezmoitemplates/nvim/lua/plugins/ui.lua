local util = require("util")

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      local add_bold_and_underline = function(name)
        vim.api.nvim_set_hl(0, name, {
          bold = true,
          fg = vim.api.nvim_get_hl(0, { name = name }).fg,
          underline = true,
        })
      end

      local callback = function()
        local eyeliner = require("eyeliner")

        eyeliner.disable()
        eyeliner.enable()

        add_bold_and_underline("EyelinerPrimary")
        add_bold_and_underline("EyelinerSecondary")

        vim.api.nvim_exec_autocmds("CursorMoved", { group = "Eyeliner" })
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
    commit = "af58360b3070650b0d151210e9c63df92ce78f3e",
    config = function(_, opts)
      require("ibl").setup(opts)

      local hooks = require("ibl.hooks")

      local ts_rainbow_2_hl = util.map(
        util.rainbow_colors,
        function(rainbow_color)
          return rainbow_color .. "TSRainbow"
        end
      )

      local ts_rainbow_hl = {}

      for i = 1, 7 do
        table.insert(ts_rainbow_hl, "rainbowcol" .. i)
      end

      local hl_is_not_default = function(hl_name)
        local hl = vim.api.nvim_get_hl(0, { name = hl_name })
        return next(hl) and not hl.default
      end

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        if hl_is_not_default(util.rainbow_delimiters_hl[1]) then
          return
        end

        local legacy_rainbow_hl = (
          hl_is_not_default(ts_rainbow_2_hl[1]) and ts_rainbow_2_hl
        )
          or (hl_is_not_default(ts_rainbow_hl[1]) and ts_rainbow_hl)

        if not legacy_rainbow_hl then
          error("No rainbow highlight groups found")
        end

        for i = 1, 7 do
          vim.api.nvim_set_hl(
            0,
            util.rainbow_delimiters_hl[i],
            { link = legacy_rainbow_hl[i] }
          )
        end
      end)
    end,
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      branch = "use-children",
    },
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
