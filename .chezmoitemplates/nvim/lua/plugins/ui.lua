local api = vim.api
local g = vim.g

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "jinh0/eyeliner.nvim",
    init = function()
      local add_bold_and_underline = function(name)
        api.nvim_set_hl(0, name, {
          bold = true,
          fg = api.nvim_get_hl(0, { name = name }).fg,
          underline = true,
        })
      end

      local update_eyeliner_hl = function()
        local eyeliner = require("eyeliner")

        eyeliner.disable()
        eyeliner.enable()

        add_bold_and_underline("EyelinerPrimary")
        add_bold_and_underline("EyelinerSecondary")

        api.nvim_exec_autocmds("CursorMoved", { group = "Eyeliner" })
      end

      update_eyeliner_hl()

      api.nvim_create_autocmd("ColorScheme", {
        callback = update_eyeliner_hl,
      })
    end,
    event = { "BufNewFile", "BufReadPre" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      local link_hl = function()
        for i = 1, 7 do
          api.nvim_set_hl(0, "IndentBlanklineIndent" .. i, { link = "rainbowcol" .. i })
        end
      end

      link_hl()

      api.nvim_create_autocmd("ColorScheme", {
        callback = link_hl,
      })
    end,
    opts = {
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
        "IndentBlanklineIndent7",
      },
      show_current_context = true,
      use_treesitter = true,
    },
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      g.miniindentscope_disable = true
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
            event = "msg_show",
            kind = "search_count",
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
    "kevinhwang91/nvim-hlslens",
    event = { "BufNewFile", "BufReadPost" },
    keys = function()
      local keys = {}

      for _, key in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
        table.insert(keys, {
          key,
          function()
            vim.cmd.normal((key == "n" or key == "N") and {
              vim.v.count1 .. key,
              bang = true,
            } or key)
            require("hlslens").start()
          end,
        })
      end

      return keys
    end,
    opts = {
      calm_down = true,
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    init = function()
      local link_hl = function()
        local rainbow_delimiters_highlight = require("rainbow-delimiters.default").highlight

        for i = 1, 7 do
          api.nvim_set_hl(0, rainbow_delimiters_highlight[i], { link = "rainbowcol" .. i })
        end
      end

      link_hl()

      api.nvim_create_autocmd("ColorScheme", {
        callback = link_hl,
      })
    end,
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
