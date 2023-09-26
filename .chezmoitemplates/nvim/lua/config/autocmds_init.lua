vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd.syntax("match", "CR", "/\r$/", "conceal")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.keymap.set("x", "<Space>cL", function()
      pcall(
        loadstring(
          table.concat(
            (
              vim.fn.getline(
                (
                  vim.fn.line("'<") --[[@as integer]]
                ),
                vim.fn.line("'>")
              ) --[=[@as string[]]=]
            ),
            "\n"
          )
        ) --[[@as fun(...):...unknown]]
      )
    end, { buffer = 0, desc = "Execute Range" })
  end,
  pattern = "*/lua/*.lua",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
  pattern = "cue",
})

if vim.env.TMUX then
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    callback = function()
      vim.system({
        "tmux",
        "rename-window",
        (
          (vim.fn.expand("%:p") --[[@as string]]):gsub(
            vim.loop.os_homedir() or "",
            "~"
          )
        ),
      })
    end,
  })
end
