local specs = {
  {
    "jinh0/eyeliner.nvim",
    init = function()
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
        "copilot-chat",
        "help",
        "lazy",
        "minifiles",
        "qf",
        "snacks_picker_list",
        "snacks_terminal",
        "trouble",
      },
    },
  },
  {
    "folke/flash.nvim",
    init = function()
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").add({
          mode = { "n", "o", "x" },
          { ",", desc = "Previous match" },
          { ";", desc = "Next match" },
        })
      end)
    end,
    opts = {
      highlight = {
        backdrop = false,
      },
      label = {
        after = false,
        before = true,
        rainbow = {
          enabled = true,
        },
        uppercase = false,
      },
      modes = {
        char = {
          autohide = true,
          config = function(opts)
            opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true) == "n"
          end,
          highlight = {
            backdrop = false,
          },
          label = {
            exclude = "acdghijklrx",
          },
        },
        search = {
          enabled = true,
        },
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    keys = {
      { "gX", "<cmd>Browse<cr>", desc = "Browse", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    "echasnovski/mini.move",
    keys = function()
      local keys = {}

      for key, direction in pairs({
        h = "Left",
        j = "Down",
        k = "Up",
        l = "Right",
      }) do
        table.insert(keys, "<S-" .. direction .. ">")
        table.insert(keys, { "<M-" .. key .. ">", mode = "x" })
        table.insert(keys, {
          "<M-" .. key .. ">",
          function()
            require("mini.move").move_line(direction:lower())
          end,
          desc = "Move line " .. direction:lower(),
          mode = "i",
        })
      end

      return keys
    end,
    opts = {
      mappings = {
        line_down = "<S-Down>",
        line_left = "<S-Left>",
        line_right = "<S-Right>",
        line_up = "<S-Up>",
      },
      options = {
        reindent_linewise = false,
      },
    },
  },
  {
    "echasnovski/mini.operators",
    keys = {
      { "gR", desc = "Replace operator" },
      { "gR", desc = "Replace selection", mode = "x" },
      { "gRR", desc = "Replace line" },
      { "gS", desc = "Sort operator" },
      { "gS", desc = "Sort selection", mode = "x" },
      { "gSS", desc = "Sort line" },
      { "gx", desc = "Exchange operator" },
      { "gx", desc = "Exchange selection", mode = "x" },
      { "gxx", desc = "Exchange line" },
    },
    opts = {
      exchange = {
        prefix = "gx",
      },
      replace = {
        prefix = "gR",
      },
      sort = {
        prefix = "gS",
      },
    },
  },
  {
    "jake-stewart/multicursor.nvim",
    keys = {
      {
        "<C-Up>",
        function()
          require("multicursor-nvim").lineAddCursor(-1)
        end,
        mode = { "n", "x" },
      },
      {
        "<C-Down>",
        function()
          require("multicursor-nvim").lineAddCursor(1)
        end,
        mode = { "n", "x" },
      },
      {
        "<C-LeftMouse>",
        function()
          require("multicursor-nvim").handleMouse()
        end,
      },
      {
        "<C-LeftDrag>",
        function()
          require("multicursor-nvim").handleMouseDrag()
        end,
      },
      {
        "<esc>",
        function()
          local mc = require("multicursor-nvim")

          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          end
        end,
      },
    },
    opts = {},
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "/" },
      { "?" },
      {
        "n",
        "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
      },
      {
        "N",
        "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
      },
      { "*", "*<cmd>lua require('hlslens').start()<cr>" },
      { "#", "#<cmd>lua require('hlslens').start()<cr>" },
      {
        "g*",
        "g*<cmd>lua require('hlslens').start()<cr>",
        desc = "Search word forward",
      },
      {
        "g#",
        "g#<cmd>lua require('hlslens').start()<cr>",
        desc = "Search word backward",
      },
    },
    opts = {
      calm_down = true,
    },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = vim
      .iter({ "b", "e", "ge", "w" })
      :map(function(key)
        return {
          key,
          "<cmd>lua require('spider').motion('" .. key .. "')<cr>",
          mode = { "n", "o", "x" },
        }
      end)
      :totable(),
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    keys = vim
      .iter({
        iS = { "inner", "subword" },
        aS = { "outer", "subword" },
        C = { "toNextClosingBracket" },
        Q = { "toNextQuotationMark" },
        gG = { "entireBuffer" },
        i_ = { "inner", "lineCharacterwise" },
        a_ = { "outer", "lineCharacterwise" },
        iv = { "inner", "value" },
        av = { "outer", "value" },
        ik = { "inner", "key" },
        ak = { "outer", "key" },
      })
      :map(function(lhs, textobj)
        return {
          lhs,
          "<cmd>lua require('various-textobjs')."
            .. textobj[#textobj]
            .. "("
            .. (#textobj == 2 and "'" .. textobj[1] .. "'" or "")
            .. ")<cr>",
          desc = table.concat(textobj, " "),
          mode = { "o", "x" },
        }
      end)
      :totable(),
    opts = {
      useDefaults = false,
    },
  },
  {
    "gbprod/substitute.nvim",
    keys = {
      {
        "x",
        function()
          require("substitute").operator()
        end,
      },
      {
        "xx",
        function()
          require("substitute").line()
        end,
      },
      {
        "X",
        function()
          require("substitute").eol()
        end,
      },
      {
        "x",
        function()
          require("substitute").visual()
        end,
        mode = "x",
      },
    },
    opts = {
      on_substitute = function(param)
        require("yanky.integration").substitute()(param)
      end,
    },
  },
  {
    "johmsalas/text-case.nvim",
    keys = {
      { "ga", group = "text-case" },
      {
        "ga.",
        function()
          require("telescope").load_extension("textcase")
          require("textcase").open_telescope()
        end,
        desc = "Telescope",
        mode = { "n", "x" },
      },
    },
    opts = {},
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>" },
    },
    opts = {
      max_join_length = 1000,
      use_default_keymaps = false,
    },
  },
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    cond = not not vim.g.vscode,
    event = "LazyFile",
  },
  {
    "svban/YankAssassin.vim",
    event = "LazyFile",
  },
  {
    "gbprod/yanky.nvim",
    keys = vim.list_extend({
      { "y", false, mode = { "n", "x" } },
    }, vim.g.vscode and { { "<leader>p", false } } or {}),
    opts = {
      system_clipboard = {
        sync_with_ring = false,
      },
    },
  },
}

return vim
  .iter(specs)
  :map(function(spec)
    spec.vscode = true
    return spec
  end)
  :totable()
