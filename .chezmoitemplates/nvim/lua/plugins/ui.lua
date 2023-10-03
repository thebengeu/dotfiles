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
    branch = "use-children",
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
