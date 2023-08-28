local edit_chezmoi_path = function(source_or_target)
  return function()
    vim.cmd("edit " .. vim.fn.system({ "chezmoi", source_or_target .. "-path", vim.api.nvim_buf_get_name(0) }))
  end
end

local update_commit_push = function(flags)
  return function()
    vim.api.nvim_command("update")
    vim.api.nvim_command(
      "AsyncRun -close -mode=term -rows=5 git commit -"
        .. flags
        .. "m '"
        .. vim.fn.input("Commit summary: "):gsub("'", "\\'")
        .. "' && git push"
    )
  end
end

vim.keymap.del("x", "j")
vim.keymap.del("x", "k")

vim.keymap.set("n", "<leader>ga", update_commit_push("a"), { desc = "Git commit all" })
vim.keymap.set("n", "<leader>gc", update_commit_push(""), { desc = "Git commit" })
vim.keymap.set("n", "<leader>gP", "<Cmd>AsyncRun -close -mode=term -rows=5 git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gp", "<Cmd>AsyncRun -close -mode=term -rows=5 git pull<CR>", { desc = "Git pull" })
vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")
vim.keymap.set("n", "<space>bo", "<Cmd>%bd|e#|bd#<CR>", { desc = "Delete other buffers" })
vim.keymap.set("n", "<space>cs", edit_chezmoi_path("source"), { desc = "Chezmoi Source" })
vim.keymap.set("n", "<space>ct", edit_chezmoi_path("target"), { desc = "Chezmoi Target" })
