local toggle_term_open_mapping = (vim.g.goneovim or vim.g.neovide) and "<C-/>" or "<C-_>"

return {
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
  },
  {
    "max397574/better-escape.nvim",
    config = true,
    event = "InsertEnter",
  },
  {
    "rmagatti/auto-session",
    keys = {
      {
        "<space>qd",
        "<Cmd>Autosession delete<CR>",
        desc = "Delete Session",
      },
      {
        "<space>ql",
        function()
          require("auto-session").setup_session_lens()
          require("auto-session.session-lens").search_session()
        end,
        desc = "List Sessions",
      },
    },
    lazy = false,
    opts = function()
      local cwd = vim.loop.cwd()
      local homedir = vim.loop.os_homedir()
      local goneovim_folder = homedir .. "\\scoop\\apps\\goneovim\\current"
      local neovide_folder = (os.getenv("ProgramFiles") or "") .. "\\Neovide"

      return {
        auto_session_enable_last_session = cwd == goneovim_folder or cwd == homedir or cwd == neovide_folder,
        log_level = vim.log.levels.ERROR,
        pre_save_cmds = {
          function()
            require("neo-tree.sources.manager").close_all()
          end,
        },
        session_lens = {
          load_on_setup = false,
          previewer = true,
        },
      }
    end,
  },
  {
    "echasnovski/mini.bracketed",
    config = true,
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_by_name = {
            "node_modules",
          },
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSHighlightCapturesUnderCursor",
      "TSPlaygroundToggle",
    },
  },
  {
    "thebengeu/smart-open.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      config = function()
        if jit.os:find("Windows") then
          vim.g.sqlite_clib_path = os.getenv("ChocolateyInstall") .. "/lib/SQLite/tools/sqlite3.dll"
        end
      end,
      enabled = true,
    },
    keys = {
      {
        "<leader><space>",
        function()
          require("telescope").extensions.smart_open.smart_open()
        end,
        desc = "Smart Open",
      },
    },
  },
  {
    "aserowy/tmux.nvim",
    config = true,
    enabled = os.getenv("TMUX") ~= nil,
    keys = {
      { "<A-j>", mode = { "i", "n", "v" } },
      { "<A-k>", mode = { "i", "n", "v" } },
      "<C-h>",
      "<C-j>",
      "<C-k>",
      "<C-l>",
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        mode = "t",
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
        mode = "t",
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
        mode = "t",
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        mode = "t",
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    keys = toggle_term_open_mapping,
    opts = {
      open_mapping = toggle_term_open_mapping,
      shell = "fish",
    },
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
    "wakatime/vim-wakatime",
    event = { "BufNewFile", "BufReadPost" },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>h"] = "+hunks",
      },
      operators = {
        ["<space>z"] = "Send to REPL",
      },
    },
  },
}
