if vim.g.vscode then
  return
end

local util = require("util")

vim.api.nvim_create_autocmd("BufEnter", {
  command = "startinsert",
  pattern = "term://*",
})

vim.api.nvim_create_autocmd("BufNewFile", {
  command = "0r ~/.config/skeletons/skeleton.sh",
  pattern = "*.sh",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*/compose.yml" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    util.async_run_sh("keymap draw keymap-drawer.yaml >keymap.svg")
  end,
  pattern = "*/qmk_userspace/keymap-drawer.yaml",
})

local skip_chezmoi_apply

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local source_path = vim.api.nvim_buf_get_name(0)

    if
      source_path:match("%.chezmoiscripts")
      or source_path:match("ansible")
      or skip_chezmoi_apply
    then
      return
    end

    if source_path:match("%.chezmoidata.cue") then
      util.async_run({ "chezmoi", "apply", "--include", "templates" })
    elseif source_path:match("%.bat%.cue") then
      util.async_run({
        "chezmoi",
        "apply",
        "--include",
        "externals,scripts",
      })
    elseif source_path:match("%.chezmoiexternals%%.cue") then
      util.async_run({ "chezmoi", "apply", "--include", "externals" })
    elseif source_path:match("%.cue") then
      util.async_run({
        "chezmoi",
        "apply",
        "--include",
        "externals,templates",
      })
    elseif source_path:match("%.chezmoitemplates") then
      local chezmoi_source_dir = " ~/.local/share/chezmoi/"
      local app_data_if_windows = jit.os == "Windows"
          and chezmoi_source_dir .. "AppData"
        or ""
      source_path = "$(rg --files-with-matches --glob '*.tmpl' "
        .. source_path:gsub(".*%.chezmoitemplates.", ""):gsub("\\", "/")
        .. app_data_if_windows
        .. chezmoi_source_dir
        .. "dot_config | sort | head -n1)"
      util.async_run_sh(
        "chezmoi apply --keep-going --source-path " .. source_path
      )
    elseif source_path:match("%.chezmoi%.yaml%.tmpl") then
      util.async_run({ "chezmoi", "init" })
    elseif source_path:match("chezmoi[/\\]%.") then
      util.async_run_sh(
        "chezmoi apply --keep-going --exclude scripts; chezmoi apply --keep-going --include scripts"
      )
    else
      util.async_run_sh(
        "! chezmoi managed -p source-absolute --include files | rg --quiet '"
          .. source_path:gsub("\\", "/")
          .. "' || chezmoi apply --keep-going --source-path '"
          .. source_path
          .. "'"
      )
    end
  end,
  pattern = "*/.local/share/chezmoi/*",
})

vim.keymap.set("n", "<leader>ua", function()
  skip_chezmoi_apply = not skip_chezmoi_apply
end, { desc = "Toggle Chezmoi Apply" })

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
    local italic_hl = vim.tbl_extend("force", comment_hl, { italic = true })

    vim.api.nvim_set_hl(0, "Comment", italic_hl)
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    local buf = args.buf
    local interval = 10
    local timer = vim.uv.new_timer()
    local timer_closing

    local set_modifiable = function(value)
      vim.api.nvim_set_option_value("modifiable", value, { buf = buf })
    end

    local delete_trailing_blank_lines = function()
      while
        vim.api.nvim_buf_line_count(buf) > 1
        and vim.api.nvim_buf_get_lines(buf, -2, -1, true)[1] == ""
      do
        vim.api.nvim_buf_set_lines(buf, -2, -1, true, {})
      end
    end

    timer:start(
      interval,
      interval,
      vim.schedule_wrap(function()
        if timer_closing then
          return
        end

        if vim.api.nvim_buf_is_valid(buf) then
          local modifiable =
            vim.api.nvim_get_option_value("modifiable", { buf = buf })

          set_modifiable(true)
          delete_trailing_blank_lines()
          set_modifiable(modifiable)

          if
            not vim.api
              .nvim_buf_get_lines(buf, -2, -1, true)[1]
              :match("Process exited 0")
          then
            return
          end

          set_modifiable(true)
          vim.api.nvim_buf_set_lines(buf, -2, -1, true, {})
          delete_trailing_blank_lines()
          set_modifiable(modifiable)
        end

        timer:stop()
        timer:close()
        timer_closing = true
      end)
    )
  end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if
      (vim.fn.getline(".") --[[@as string]]):match("^%s*,%s*$")
    then
      vim.cmd.undojoin()
      vim.fn.deletebufline("", vim.fn.line("."))
    end
  end,
  pattern = "*.lua",
})

if vim.env.TITLE_PREFIX == "wsl:" then
  vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
    vim.g.clipboard = {
      copy = {
        ["*"] = { "win32yank.exe", "-i", "--crlf" },
        ["+"] = { "win32yank.exe", "-i", "--crlf" },
      },
      name = "win32yank",
      paste = {
        ["*"] = { "win32yank.exe", "-o", "--lf" },
        ["+"] = { "win32yank.exe", "-o", "--lf" },
      },
    }
  end)
elseif vim.env.SSH_CONNECTION then
  local maybe_create_osc52_autocmd = function()
    vim.schedule(function()
      vim.opt.clipboard = ""

      local copy = require("vim.ui.clipboard.osc52").copy("+")

      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == "y" and vim.v.event.regname == "" then
            ---@diagnostic disable-next-line: param-type-mismatch
            copy(vim.fn.getreg(vim.v.event.regname, 0, 1))
          end
        end,
      })
    end)
  end

  if vim.fn.executable("lmn") == 1 then
    vim.system({ "lmn", "paste" }, nil, function(system_obj)
      if system_obj.code == 0 then
        vim.g.clipboard = {
          cache_enabled = 1,
          copy = {
            ["*"] = { "lmn", "copy" },
            ["+"] = { "lmn", "copy" },
          },
          name = "lemonade",
          paste = {
            ["*"] = { "lmn", "paste" },
            ["+"] = { "lmn", "paste" },
          },
        }
      else
        maybe_create_osc52_autocmd()
      end
    end)
  else
    maybe_create_osc52_autocmd()
  end
end

local serverstart_unused_port
serverstart_unused_port = function(port)
  vim.system(
    { "ncat", "-z", "--wait", "1ms", "127.0.0.1", port },
    nil,
    function(system_obj)
      if system_obj.code == 0 then
        serverstart_unused_port(port + 1)
      else
        vim.schedule(function()
          vim.fn.serverstart("127.0.0.1:" .. port)
          util.wezterm_set_user_var("NVIM_PORT", port)

          vim.api.nvim_create_autocmd("FocusGained", {
            callback = function()
              util.wezterm_set_user_var("FOCUSED_NVIM_TIME", os.time())
            end,
          })

          vim.api.nvim_create_autocmd("VimLeave", {
            callback = function()
              if vim.env.KITTY_WINDOW_ID then
                vim.system({ "kitten", "@", "set-colors", "--reset" })
              end

              util.wezterm_set_user_var("NVIM_PORT", "")
              util.wezterm_set_user_var("FOCUSED_NVIM_TIME", "")
            end,
          })
        end)
      end
    end
  )
end

util.wezterm_set_user_var("FOCUSED_NVIM_TIME", os.time())
serverstart_unused_port(6789)
