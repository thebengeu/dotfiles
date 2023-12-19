local util = require("util")

vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")

vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")
vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")

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

  vim.keymap.set("n", "<c-/>", function()
    require("vscode-neovim").action("workbench.action.terminal.toggleTerminal")
  end)

  vim.schedule(function()
    for _, mode in ipairs({ "n", "x" }) do
      for _, keymap in ipairs(vim.api.nvim_get_keymap(mode)) do
        local lhs = keymap.lhs

        if lhs:match("^ .+") then
          vim.keymap.del(mode, lhs)
        end
      end
    end
  end)

  return
end

vim.keymap.set("n", "<leader>gB", function()
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

vim.keymap.set("n", "<leader>gR", function()
  util.async_run_sh("git push && gh pr create --fill && gh pr view --web")
end, { desc = "Create Draft PR" })

vim.keymap.set("n", "<leader>gr", function()
  util.async_run_sh(
    "git push && gh pr create --draft --fill && gh pr view --web"
  )
end, { desc = "Create Draft PR" })

vim.keymap.set("n", "<leader>gv", function()
  util.async_run_sh("gh pr view --web")
end, { desc = "View PR" })

vim.keymap.set(
  "n",
  "<leader>gw",
  util.async_run_git({ "wip" }),
  { desc = "Commit WIP" }
)

vim.keymap.set("n", "<leader>um", function()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.mouse = vim.opt.mouse:get().a and "" or "a"
end, { desc = "Toggle Mouse" })

vim.keymap.set("n", "<leader>cu", function()
  util.async_run_sh(
    "chezmoi update --apply=false; chezmoi init; chezmoi apply --exclude scripts; chezmoi apply --include scripts"
  )
end, { desc = "Chezmoi update" })

vim.keymap.set({ "i", "n" }, "<C-_>", "<C-/>", { remap = true })

if vim.g.goneovim or vim.g.neovide then
  vim.keymap.set("n", "<C-v>", "a<C-r>+<Esc>")
  vim.keymap.set({ "c", "i" }, "<C-v>", "<C-r>+")
end

require("config.keymaps_git_commit")
