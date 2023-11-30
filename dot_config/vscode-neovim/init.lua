local map = function(input, callback)
  local output = {}

  if type(input) == "table" then
    for key, value in pairs(input) do
      table.insert(output, callback(value, key))
    end
  else
    for value in input do
      table.insert(output, callback(value))
    end
  end

  return output
end

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.clipboard = "unnamedplus"
vim.opt.gdefault = true
vim.opt.report = 999

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
        mode = { "n", "x" },
      },
      {
        "<C-x>",
        "<Plug>(dial-decrement)",
        mode = { "n", "x" },
      },
      {
        "g<C-a>",
        "g<Plug>(dial-increment)",
        mode = { "n", "x" },
        remap = true,
      },
      {
        "g<C-x>",
        "g<Plug>(dial-decrement)",
        mode = { "n", "x" },
        remap = true,
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
    event = "VeryLazy",
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
      },
    },
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
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")

      return {
        custom_textobjects = {
          d = ai.gen_spec.treesitter(
            { a = "@function.outer", i = "@function.inner" },
            {}
          ),
        },
      }
    end,
  },
  {
    "echasnovski/mini.move",
    keys = function()
      local keys = {
        {
          "[e",
          function()
            require("mini.move").move_line("up")
          end,
        },
        {
          "]e",
          function()
            require("mini.move").move_line("down")
          end,
        },
      }

      for key, direction in pairs({
        h = "Left",
        j = "Down",
        k = "Up",
        l = "Right",
      }) do
        table.insert(keys, "<S-" .. direction .. ">")
        table.insert(keys, { "<M-" .. key .. ">", mode = "v" })
        table.insert(keys, {
          "<M-" .. key .. ">",
          function()
            require("mini.move").move_line(direction:lower())
          end,
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
    "echasnovski/mini.surround",
    keys = {
      { "gsa", mode = { "n", "v" } },
      "gsd",
      "gsf",
      "gsF",
      "gsh",
      "gsr",
      "gsn",
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = map({ "b", "e", "ge", "w" }, function(key)
      return {
        key,
        "<Cmd>lua require('spider').motion('" .. key .. "')<CR>",
        mode = { "n", "o", "x" },
      }
    end),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "tsx",
        "typescript",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    keys = map({
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
    }, function(textobj, lhs)
      return {
        lhs,
        "<Cmd>lua require('various-textobjs')."
          .. textobj[#textobj]
          .. "("
          .. (#textobj == 2 and "'" .. textobj[1] .. "'" or "")
          .. ")<CR>",
        mode = { "o", "x" },
      }
    end),
    opts = {
      useDefaultKeymaps = false,
    },
  },
  {
    "gbprod/substitute.nvim",
    opts = {
      on_substitute = function()
        require("yanky.integration").substitute()
      end,
    },
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
    "kkharji/sqlite.lua",
    lazy = true,
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
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
  },
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
  },
  {
    "svban/YankAssassin.vim",
    event = "VeryLazy",
  },
  {
    "gbprod/yanky.nvim",
    dependencies = "kkharji/sqlite.lua",
    keys = {
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
      { "[y", "<Plug>(YankyCycleForward)" },
      { "]y", "<Plug>(YankyCycleBackward)" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },
      { "=p", "<Plug>(YankyPutAfterFilter)" },
      { "=P", "<Plug>(YankyPutBeforeFilter)" },
    },
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.api.nvim_create_user_command("LazyPlugins", function()
  local plugins = map(require("lazy").plugins(), function(plugin)
    return plugin.name
  end)

  table.sort(plugins)

  print(table.concat(plugins, ", "))
end, {})

vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")

vim.keymap.set("n", "[<Space>", function()
  vim.fn.append(vim.fn.line(".") - 1, "")
end)

vim.keymap.set("n", "]<Space>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.append(vim.fn.line("."), "")
end)

-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
vim.keymap.set("n", "dd", function()
  return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- https://nanotipsforvim.prose.sh/repeated-v-in-visual-line-mode
vim.keymap.set("x", "V", "j")

vim.keymap.set({ "n", "x" }, "<Space>", function()
  require("vscode-neovim").action("vspacecode.space")
end)

vim.keymap.set("n", "<c-/>", function()
  require("vscode-neovim").action("workbench.action.terminal.toggleTerminal")
end)
