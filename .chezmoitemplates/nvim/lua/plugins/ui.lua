local util = require("util")

return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "folke/edgy.nvim",
    opts = {
      animate = { enabled = false },
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          pinned = true,
          open = function()
            vim.api.nvim_input("<esc><space>e")
          end,
          size = { height = 0.5 },
        },
        { title = "Neotest Summary", ft = "neotest-summary" },
        "neo-tree",
      },
    },
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
    event = "LazyFile",
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
        local hl = vim.api.nvim_get_hl(0, { name = rainbow_hl[1] })

        return next(hl) ~= nil and not hl.default and rainbow_hl
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
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c = util.filter(
        opts.sections.lualine_c,
        function(components)
          return components[1] ~= "aerial"
        end
      )

      return opts
    end,
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
    event = "LazyFile",
  },
  {
    "lewis6991/satellite.nvim",
    enabled = vim.version().minor >= 10,
    event = "LazyFile",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").register({
          ["<LeftMouse>"] = "which_key_ignore",
          mode = { "i", "n", "o", "v" },
        })
      end)
    end,
    opts = {},
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "LazyFile",
    opts = {
      setopt = true,
    },
  },
}
