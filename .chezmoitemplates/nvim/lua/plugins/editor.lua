local map = require("util").map

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
      ignore_filetypes = {
        "lazy",
        "mason",
        "NeogitStatus",
        "neo%-tree",
        "qf",
      },
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
    "folke/flash.nvim",
    ---@type Flash.Config
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
        reuse = "all",
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
        },
      },
    },
  },
  {
    "chentoast/marks.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      sign_priority = 13,
    },
  },
  {
    "echasnovski/mini.move",
    keys = vim.list_extend(
      {
        { "<M-h>", mode = "v" },
        { "<M-j>", mode = "v" },
        { "<M-k>", mode = "v" },
        { "<M-l>", mode = "v" },
        { "<S-Down>" },
        { "<S-Left>" },
        { "<S-Right>" },
        { "<S-Up>" },
      },
      map({
        h = "left",
        j = "down",
        k = "up",
        l = "right",
      }, function(direction, key)
        return {
          "<M-" .. key .. ">",
          function()
            require("mini.move").move_line(direction)
          end,
          desc = "Move line " .. direction,
          mode = "i",
        }
      end)
    ),
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
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      map_c_h = true,
      map_c_w = true,
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
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    opts = {
      completion = false,
    },
  },
  {
    "johmsalas/text-case.nvim",
    config = true,
    keys = {
      { "ga", desc = "+text-case" },
    },
  },
  {
    "cappyzawa/trim.nvim",
    config = true,
    event = "BufWritePre",
  },
  {
    "tpope/vim-repeat",
    config = function()
      vim.api.nvim_exec(
        [[
          function! s:Map(...) abort
            let [mode, head, rhs; rest] = a:000
            let flags = get(rest, 0, '') . (rhs =~# '^<Plug>' ? '' : '<script>')
            let tail = ''
            let keys = get(g:, mode.'remap', {})
            if type(keys) == type({}) && !empty(keys)
              while !empty(head) && len(keys)
                if has_key(keys, head)
                  let head = keys[head]
                  if empty(head)
                    let head = '<skip>'
                  endif
                  break
                endif
                let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
                let head = substitute(head, '<[^<>]*>$\|.$', '', '')
              endwhile
            endif
            if head !=# '<skip>' && empty(maparg(head.tail, mode))
              return mode.'map ' . flags . ' ' . head.tail . ' ' . rhs
            endif
            return ''
          endfunction

          " Section: Line operations

          function! s:BlankUp() abort
            let cmd = 'put!=repeat(nr2char(10), v:count1)|silent '']+'
            if &modifiable
              let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-up)", v:count1)'
            endif
            return cmd
          endfunction

          function! s:BlankDown() abort
            let cmd = 'put =repeat(nr2char(10), v:count1)|silent ''[-'
            if &modifiable
              let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-down)", v:count1)'
            endif
            return cmd
          endfunction

          nnoremap <silent> <Plug>(unimpaired-blank-up)   :<C-U>exe <SID>BlankUp()<CR>
          nnoremap <silent> <Plug>(unimpaired-blank-down) :<C-U>exe <SID>BlankDown()<CR>

          nnoremap <silent> <Plug>unimpairedBlankUp   :<C-U>exe <SID>BlankUp()<CR>
          nnoremap <silent> <Plug>unimpairedBlankDown :<C-U>exe <SID>BlankDown()<CR>

          function! s:ExecMove(cmd) abort
            let old_fdm = &foldmethod
            if old_fdm !=# 'manual'
              let &foldmethod = 'manual'
            endif
            normal! m`
            silent! exe a:cmd
            norm! ``
            if old_fdm !=# 'manual'
              let &foldmethod = old_fdm
            endif
          endfunction

          function! s:Move(cmd, count, map) abort
            call s:ExecMove('move'.a:cmd.a:count)
            silent! call repeat#set("\<Plug>(unimpaired-move-".a:map.")", a:count)
          endfunction

          function! s:MoveSelectionUp(count) abort
            call s:ExecMove("'<,'>move'<--".a:count)
            silent! call repeat#set("\<Plug>(unimpaired-move-selection-up)", a:count)
          endfunction

          function! s:MoveSelectionDown(count) abort
            call s:ExecMove("'<,'>move'>+".a:count)
            silent! call repeat#set("\<Plug>(unimpaired-move-selection-down)", a:count)
          endfunction

          nnoremap <silent> <Plug>(unimpaired-move-up)            :<C-U>call <SID>Move('--',v:count1,'up')<CR>
          nnoremap <silent> <Plug>(unimpaired-move-down)          :<C-U>call <SID>Move('+',v:count1,'down')<CR>
          noremap  <silent> <Plug>(unimpaired-move-selection-up)   :<C-U>call <SID>MoveSelectionUp(v:count1)<CR>
          noremap  <silent> <Plug>(unimpaired-move-selection-down) :<C-U>call <SID>MoveSelectionDown(v:count1)<CR>
          nnoremap <silent> <Plug>unimpairedMoveUp            :<C-U>call <SID>Move('--',v:count1,'up')<CR>
          nnoremap <silent> <Plug>unimpairedMoveDown          :<C-U>call <SID>Move('+',v:count1,'down')<CR>
          noremap  <silent> <Plug>unimpairedMoveSelectionUp   :<C-U>call <SID>MoveSelectionUp(v:count1)<CR>
          noremap  <silent> <Plug>unimpairedMoveSelectionDown :<C-U>call <SID>MoveSelectionDown(v:count1)<CR>
        ]],
        false
      )
    end,
    keys = {
      { "[e", "<Plug>(unimpaired-move-up)", desc = "Exchange line with lines above" },
      { "]e", "<Plug>(unimpaired-move-down)", desc = "Exchange line with lines below" },
      { "[e", "<Plug>(unimpaired-move-selection-up)", mode = "x", desc = "Exchange selection with lines above" },
      { "]e", "<Plug>(unimpaired-move-selection-down)", mode = "x", desc = "Exchange selection with lines below" },
      { "[<Space>", "<Plug>(unimpaired-blank-up)", desc = "Add blank lines above" },
      { "]<Space>", "<Plug>(unimpaired-blank-down)", desc = "Add blank lines below" },
    },
  },
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-g>",
        ["Find Subword Under"] = "<C-g>",
      }
    end,
    keys = {
      "<C-g>",
      "<C-Down>",
      "<C-Up>",
      "\\\\",
      "\\\\A",
    },
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "y", false, mode = { "n", "x" } },
    },
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
}
