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
