return {
  {
    "ja-ford/delaytrain.nvim",
    keys = {
      "<Down>",
      "<Left>",
      "<Right>",
      "<Up>",
      "h",
      "j",
      "k",
      "l",
    },
    opts = {
      grace_period = 2,
      ignore_filetypes = { "neo%-tree", "qf" },
    },
  },
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")

      vim.list_extend(require("dial.config").augends.group.default, {
        augend.constant.alias.bool,
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "and", "or" } }),
      })
    end,
    keys = {
      {
        "<C-a>",
        "<Plug>(dial-increment)",
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
      },
      {
        "<C-a>",
        "<Plug>(dial-increment)",
        { mode = "v" },
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
        { mode = "v" },
      },
      {
        "g<C-a>",
        "g<Plug>(dial-increment)",
        { mode = "v" },
      },
      {
        "g<C-x>",
        "g<Plug>(dial-decrement)",
        { mode = "v" },
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    config = true,
    lazy = true,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "echasnovski/mini.ai",
    config = function(plugin, opts)
      local super = plugin._.super
      super.config(super, opts)

      require("which-key").register({
        af = "Function call",
        ["if"] = "Function call",
        mode = { "o", "x" },
      })
    end,
    keys = {
      { "ad", desc = "Function definition", mode = { "o", "x" } },
      { "id", desc = "Function definition", mode = { "o", "x" } },
    },
    opts = function(_, opts)
      opts.custom_textobjects.d = opts.custom_textobjects.f
      opts.custom_textobjects.f = nil
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup({
          method = "getPanelCompletions",
          formatters = {
            insert_text = require("copilot_cmp.format").remove_existing,
          },
        })
      end,
      dependencies = {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            panel = { enabled = false },
            suggestion = { enabled = false },
          })
        end,
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          require("copilot_cmp.comparators").score,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "copilot" },
      }))
    end,
  },
  {
    "mfussenegger/nvim-treehopper",
    keys = {
      { "p", ":<C-U>lua require('tsht').nodes()<CR>", desc = "Nodes", mode = "o" },
      {
        "p",
        ":lua require('tsht').nodes()<CR>",
        desc = "Nodes",
        mode = "x",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        keys = {
          {
            ";",
            function()
              require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move()
            end,
            desc = "Last move",
            mode = { "n", "o", "x" },
          },
          {
            ",",
            function()
              require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_opposite()
            end,
            desc = "Last move opposite",
            mode = { "n", "o", "x" },
          },
        },
      },
    },
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "fish",
        "gitignore",
        "prisma",
        "toml",
      })
      opts.matchup = {
        disable_virtual_text = true,
        enable = true,
      }
      opts.rainbow = {
        enable = true,
        extended_mode = true,
      }
      opts.textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["=l"] = {
              desc = "Select assignment LHS",
              query = "@assignment.lhs",
            },
            ["=r"] = {
              desc = "Select assignment RHS",
              query = "@assignment.rhs",
            },
          },
          lookahead = true,
        },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true,
    event = "InsertEnter",
  },
  {
    "linty-org/readline.nvim",
    keys = {
      {
        "<C-a>",
        function()
          require("readline").dwim_beginning_of_line()
        end,
        mode = "!",
      },
      {
        "<C-e>",
        function()
          require("readline").end_of_line()
        end,
        mode = "!",
      },
      {
        "<C-u>",
        function()
          require("readline").dwim_backward_kill_line()
        end,
        mode = "!",
      },
      {
        "<C-w>",
        function()
          require("readline").unix_word_rubout()
        end,
        mode = "!",
      },
      {
        "<M-BS>",
        function()
          require("readline").backward_kill_word()
        end,
        mode = "!",
      },
      {
        "<M-b>",
        function()
          require("readline").backward_word()
        end,
        mode = "!",
      },
      {
        "<M-d>",
        function()
          require("readline").kill_word()
        end,
        mode = "!",
      },
      {
        "<M-f>",
        function()
          require("readline").forward_word()
        end,
        mode = "!",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>cF",
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        desc = "Refactor",
        mode = { "n", "v" },
      },
    },
  },
  {
    "gbprod/substitute.nvim",
    event = { "BufNewFile", "BufReadPost" },
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
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    opts = {
      completion = false,
    },
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<Cmd>TSJToggle<CR>" },
    },
    opts = {
      use_default_keymaps = false,
    },
  },
  {
    "andymass/vim-matchup",
    config = function()
      require("which-key").register({
        ["a%"] = "any block",
        ["i%"] = "inner any block",
      }, { mode = "o" })
    end,
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "mg979/vim-visual-multi",
    keys = {
      "<C-Down>",
      "<C-Up>",
      "<C-n>",
      "\\\\",
      "\\\\A",
    },
  },
}
