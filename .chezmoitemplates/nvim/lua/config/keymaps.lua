local LazyVim = require("lazyvim.util")
local util = require("util")

vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")
vim.keymap.del("n", "<leader>gl")
vim.keymap.del("n", "<leader>gL")

vim.keymap.set("n", "<C-r>", "<cmd>silent redo<cr>")
vim.keymap.set("n", "u", "<cmd>silent undo<cr>")

vim.keymap.set("n", "[<Space>", function()
  vim.fn.append(vim.fn.line(".") - 1, "")
end, { desc = "Add blank line above" })

vim.keymap.set("n", "]<Space>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.append(vim.fn.line("."), "")
end, { desc = "Add blank line below" })

-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
vim.keymap.set("n", "dd", function()
  return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { desc = "Line", expr = true })

-- https://nanotipsforvim.prose.sh/repeated-v-in-visual-line-mode
vim.keymap.set("x", "V", "j")

if vim.g.vscode then
  vim.keymap.set({ "n", "x" }, "<leader>", function()
    require("vscode-neovim").action("vspacecode.space")
  end)

  vim.keymap.set("n", "<C-/>", function()
    require("vscode-neovim").action("workbench.action.terminal.toggleTerminal")
  end)

  vim.schedule(function()
    for _, mode in ipairs({ "n", "x" }) do
      for _, keymap in ipairs(vim.api.nvim_get_keymap(mode)) do
        local lhs = keymap.lhs

        if lhs and lhs:match("^ .+") then
          vim.keymap.del(mode, lhs)
        end
      end
    end
  end)

  return
end

vim.keymap.set("n", "<leader>fC", function()
  vim.cmd.edit("~/thebengeu/cheatsheet/README.md")
end, { desc = "Cheatsheet" })

vim.keymap.set("n", "<leader>gW", function()
  local new_branch_name = vim.fn.input("New branch name: ", "beng/")

  if new_branch_name ~= "" then
    util.async_run_git({ "switch", "--create", new_branch_name })()
  end
end, { desc = "New branch" })

vim.keymap.set(
  "n",
  "<leader>gP",
  util.async_run_git({ "push" }),
  { desc = "Push" }
)

vim.keymap.set(
  "n",
  "<leader>gp",
  util.async_run_git({ "pull" }),
  { desc = "Pull" }
)

vim.keymap.set("n", "<leader>gr", function()
  util.async_run_sh(
    "git push && gh pr create --fill-first && gh pr view --web",
    { cwd = LazyVim.root() }
  )
end, { desc = "Create PR" })

vim.keymap.set("n", "<leader>gR", function()
  util.async_run_sh(
    "git push && gh pr create --draft --fill-first && gh pr view --web",
    { cwd = LazyVim.root() }
  )
end, { desc = "Create Draft PR" })

vim.keymap.del({ "n", "x" }, "<leader>gB")
vim.keymap.set("n", "<leader>gB", function()
  util.async_run_sh("gh pr view --web")
end, { desc = "View PR in browser" })

vim.keymap.set(
  "n",
  "<leader>gC",
  util.async_run_git({ "wip" }),
  { desc = "Commit WIP" }
)

Snacks.toggle({
  name = "Mouse",
  get = function()
    ---@diagnostic disable-next-line: undefined-field
    return vim.opt.mouse:get().a
  end,
  set = function(state)
    vim.opt.mouse = state and "a" or ""
  end,
}):map("<leader>um")

vim.keymap.set("n", "<leader>cU", function()
  util.async_run_sh(
    "chezmoi update --apply=false; chezmoi init; chezmoi apply --keep-going --exclude scripts; chezmoi apply --keep-going --include scripts"
  )
end, { desc = "Chezmoi update" })

vim.keymap.set({ "i", "n" }, "<C-_>", "<C-/>", { remap = true })

if vim.fn.has("gui_running") == 1 then
  if jit.os == "Windows" then
    vim.keymap.set("n", "<C-v>", "a<C-r>+<Esc>")
    vim.keymap.set({ "c", "i" }, "<C-v>", "<C-r>+")
  else
    vim.keymap.set({ "i", "n", "x" }, "<D-p>", util.smart())
    vim.keymap.set("n", "<D-v>", "a<C-r>+<Esc>")
    vim.keymap.set({ "c", "i" }, "<D-v>", "<C-r>+")
    vim.keymap.set("n", "<D-z>", "u", { remap = true })
    vim.keymap.set("i", "<D-z>", "<C-o>u", { remap = true })
  end
end

require("config.keymaps_git_commit")
