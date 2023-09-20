local async_run = require("util").async_run
local base64 = require("util.base64")

vim.api.nvim_create_autocmd("BufEnter", {
  command = "startinsert",
  pattern = "term://*",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local source_path = vim.api.nvim_buf_get_name(0)

    if
      source_path:find("run_onchange_")
      or source_path:find("ansible")
      or vim.g.skip_chezmoi_apply
    then
      return
    end

    if source_path:find("%.chezmoidata.cue") then
      async_run({ "chezmoi", "apply", "--include", "templates" })
    elseif source_path:find("%.chezmoiexternal.cue") then
      async_run({ "chezmoi", "apply", "--include", "externals" })
    elseif source_path:find("%.chezmoitemplates") then
      local rg_command_prefix = "rg --files-with-matches --glob '*.tmpl' "
        .. source_path:gsub(".*%.chezmoitemplates.", ""):gsub("\\", "/")
        .. " ~/.local/share/chezmoi/"
      source_path = "$(test $OS = Windows_NT && "
        .. rg_command_prefix
        .. "AppData || "
        .. rg_command_prefix
        .. "dot_config)"
      async_run({ "sh", "-c", "chezmoi apply --source-path " .. source_path })
    elseif source_path:find("%.chezmoi%.yaml%.tmpl") then
      async_run({ "chezmoi", "init" })
    elseif source_path:find("chezmoi[/\\]%.") then
      async_run({ "chezmoi", "apply" })
    else
      async_run({
        "chezmoi",
        "apply",
        "--source-path",
        source_path,
      })
    end
  end,
  pattern = "*/.local/share/chezmoi/*",
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if
      (vim.fn.getline(".") --[[@as string]]):find("^%s*,%s*$")
    then
      vim.cmd.undojoin()
      vim.fn.deletebufline("", vim.fn.line("."))
    end
  end,
  pattern = "*.lua",
})

if vim.env.TMUX then
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    callback = function()
      vim.fn.system(
        "tmux rename-window '"
          .. (vim.fn.expand("%:p") --[[@as string]]):gsub(
            vim.loop.os_homedir() or "",
            "~"
          )
          .. "'"
      )
    end,
  })
end

vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    if vim.v.event.status == 0 then
      vim.cmd.bdelete({ args.buf, bang = true })
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd.syntax("match", "CR", "/\r$/", "conceal")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
  pattern = "cue",
})

local set_user_var = function(name, value)
  vim.fn.chansend(
    vim.v.stderr,
    "\x1b]1337;SetUserVar="
      .. name
      .. "="
      .. base64.encode(tostring(value))
      .. "\x07"
  )
end

local serverstart_unused_port
serverstart_unused_port = function(port)
  vim.system(
    { "ncat", "-z", "--wait", "1ms", "127.0.0.1", port },
    {},
    function(system_obj)
      if system_obj.code == 0 then
        serverstart_unused_port(port + 1)
      else
        vim.schedule(function()
          vim.fn.serverstart("127.0.0.1:" .. port)
          set_user_var("NVIM_PORT", port)
          set_user_var("FOCUSED_NVIM_TIME", os.time())

          vim.api.nvim_create_autocmd("FocusGained", {
            callback = function()
              set_user_var("FOCUSED_NVIM_TIME", os.time())
            end,
          })

          vim.api.nvim_create_autocmd("VimLeave", {
            callback = function()
              set_user_var("NVIM_PORT", "")
              set_user_var("FOCUSED_NVIM_TIME", 0)
            end,
          })
        end)
      end
    end
  )
end

serverstart_unused_port(6789)
