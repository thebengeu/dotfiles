local async_run = require("util").async_run
local base64 = require("util.base64")

vim.api.nvim_create_autocmd("BufEnter", {
  command = "startinsert",
  pattern = "term://*",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    if vim.api.nvim_buf_get_name(0):find("%-admin%.ps1") then
      return
    end
    async_run("chezmoi apply --init")()
  end,
  pattern = "*/.local/share/chezmoi/*",
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if vim.fn.getline("."):find("^%s*,%s*$") then
      vim.cmd.undojoin()
      vim.fn.deletebufline("", vim.fn.line("."))
    end
  end,
  pattern = "*.lua",
})

if vim.env.TMUX ~= nil then
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    callback = function()
      vim.fn.system("tmux rename-window '" .. vim.fn.expand("%:p"):gsub(vim.loop.os_homedir() or "", "~") .. "'")
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

local set_nvim_port_user_var = function(port)
  vim.fn.chansend(vim.v.stderr, "\x1b]1337;SetUserVar=NVIM_PORT=" .. base64.encode(tostring(port)) .. "\x07")
end

ServerstartUnusedPort = function(port)
  vim.system({ "ncat", "-z", "--wait", "1ms", "127.0.0.1", port }, {}, function(system_obj)
    if system_obj.code == 0 then
      ServerstartUnusedPort(port + 1)
    else
      vim.schedule(function()
        vim.fn.serverstart("127.0.0.1:" .. port)
        set_nvim_port_user_var(port)

        vim.api.nvim_create_autocmd("VimLeave", {
          callback = function()
            set_nvim_port_user_var("")
          end,
        })
      end)
    end
  end)
end

ServerstartUnusedPort(6789)
