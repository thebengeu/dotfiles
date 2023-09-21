local async_run = require("util").async_run

local edit_chezmoi_path = function(source_or_target)
  return function()
    vim.cmd.edit(vim.fn.system({
      "chezmoi",
      source_or_target .. "-path",
      vim.api.nvim_buf_get_name(0),
    }))
  end
end

local update_commit_push = function(flags)
  return function()
    vim.cmd.update()
    local commit_summary = vim.fn.input("Commit summary: "):gsub('"', '\\"')
    async_run({
      "sh",
      "-c",
      "git commit -" .. flags .. 'm "' .. commit_summary .. '" && git push',
    })
  end
end

vim.keymap.del("x", "j")
vim.keymap.del("x", "k")

if vim.g.goneovim or vim.g.neovide then
  vim.keymap.set("n", "<C-v>", "a<C-r>+<Esc>")
  vim.keymap.set({ "c", "i" }, "<C-v>", "<C-r>+")
end

vim.keymap.set(
  "n",
  "<leader>ga",
  update_commit_push("a"),
  { desc = "Git commit all" }
)
vim.keymap.set(
  "n",
  "<leader>gc",
  update_commit_push(""),
  { desc = "Git commit" }
)
vim.keymap.set("n", "<leader>gP", function()
  async_run({ "git", "push" })
end, { desc = "Git push" })
vim.keymap.set("n", "<leader>gp", function()
  async_run({ "git", "pull" })
end, { desc = "Git pull" })
vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")
vim.keymap.set(
  "n",
  "<space>bo",
  "<Cmd>%bd|e#|bd#<CR>",
  { desc = "Delete other buffers" }
)
vim.keymap.set(
  "n",
  "<space>cs",
  edit_chezmoi_path("source"),
  { desc = "Chezmoi Source" }
)
vim.keymap.set(
  "n",
  "<space>ct",
  edit_chezmoi_path("target"),
  { desc = "Chezmoi Target" }
)
vim.keymap.set("n", "<leader>ua", function()
  vim.g.skip_chezmoi_apply = not vim.g.skip_chezmoi_apply
end, { desc = "Toggle Chezmoi Apply" })
vim.keymap.set("n", "<leader>um", function()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.mouse = vim.opt.mouse:get().a and "" or "a"
end, { desc = "Toggle Mouse" })
vim.keymap.set("n", "[<Space>", function()
  vim.fn.append(vim.fn.line(".") - 1, "")
end, { desc = "Add blank line above" })
vim.keymap.set("n", "]<Space>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.append(vim.fn.line("."), "")
end, { desc = "Add blank line below" })
vim.keymap.set("n", "<leader>ca", function()
  async_run({ "chezmoi", "apply" })
end, { desc = "Chezmoi apply" })
vim.keymap.set("n", "<leader>cu", function()
  async_run({
    "sh",
    "-c",
    "chezmoi update --apply=false; chezmoi init; chezmoi apply",
  })
end, { desc = "Chezmoi update" })
