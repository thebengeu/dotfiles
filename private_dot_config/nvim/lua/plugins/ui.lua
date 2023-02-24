local api = vim.api
local g = vim.g

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup()

      local add_bold_and_underline = function(name)
        api.nvim_set_hl(0, name, {
          bold = true,
          fg = api.nvim_get_hl_by_name(name, true).foreground,
          underline = true,
        })
      end

      local update_eyeliner_hl = function()
        add_bold_and_underline("EyelinerPrimary")
        add_bold_and_underline("EyelinerSecondary")
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
    config = function(_, opts)
      require("indent_blankline").setup(opts)

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
    config = function(plugin, opts)
      local super = plugin._.super
      super.config(super, opts)

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
    keys = {
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "*",
        "*<Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "#",
        "#<Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "g*",
        "g*<Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "g#",
        "g#<Cmd>lua require('hlslens').start()<CR>",
      },
    },
    opts = {
      calm_down = true,
    },
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      highlight = true,
    },
  },
  {
    "mrjones2014/nvim-ts-rainbow",
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "lewis6991/satellite.nvim",
    config = true,
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
