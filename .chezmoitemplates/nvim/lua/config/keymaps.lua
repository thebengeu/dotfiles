local async_run = require("util").async_run
local Input = require("nui.input")
local Layout = require("nui.layout")
local Popup = require("nui.popup")

vim.keymap.del("x", "j")
vim.keymap.del("x", "k")

vim.keymap.set(
  "n",
  "<space>bo",
  "<Cmd>%bd|e#|bd#<CR>",
  { desc = "Delete other buffers" }
)

vim.keymap.set("n", "<leader>gc", function()
  vim.cmd.update()

  local has_staged = vim
    .system({ "git", "diff", "--cached", "--quiet" })
    :wait().code ~= 0

  local input = Input({ border = "single" }, {
    on_submit = function(commit_summary)
      if commit_summary ~= "" then
        async_run({
          "sh",
          "-c",
          "git commit -"
            .. (has_staged and "" or "a")
            .. 'm "'
            .. commit_summary:gsub('"', '\\"')
            .. '" && git push',
        })
      end
    end,
    prompt = "Commit summary: ",
  })

  local unmount = input.unmount
  input.unmount = function(self)
    if self._.loading then
      return
    end

    unmount(self)
  end

  local term = Popup({ border = "single" })

  vim.api.nvim_buf_call(term.bufnr, function()
    vim.b.leave_open = true
    vim.fn.termopen(
      "git diff"
        .. (has_staged and " --cached" or "")
        .. " | delta --pager never"
    )
  end)

  local layout = Layout(
    {
      position = "50%",
      size = "90%",
    },
    Layout.Box({
      Layout.Box(input, { size = 3 }),
      Layout.Box(term, { grow = 1 }),
    }, { dir = "col" })
  )

  layout:mount()
end, { desc = "Git commit" })

vim.keymap.set("n", "<leader>gP", function()
  async_run({ "git", "push" })
end, { desc = "Git push" })

vim.keymap.set("n", "<leader>gp", function()
  async_run({ "git", "pull" })
end, { desc = "Git pull" })

vim.keymap.set("n", "<leader>um", function()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.mouse = vim.opt.mouse:get().a and "" or "a"
end, { desc = "Toggle Mouse" })

vim.keymap.set("n", "<C-r>", "<Cmd>silent redo<CR>")

vim.keymap.set("n", "[<Space>", function()
  vim.fn.append(vim.fn.line(".") - 1, "")
end, { desc = "Add blank line above" })

vim.keymap.set("n", "]<Space>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.append(vim.fn.line("."), "")
end, { desc = "Add blank line below" })

-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "dd", function()
  return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

vim.keymap.set("n", "u", "<Cmd>silent undo<CR>")

vim.keymap.set("n", "<leader>cu", function()
  async_run({
    "sh",
    "-c",
    "chezmoi update --apply=false; chezmoi init; chezmoi apply --exclude scripts; chezmoi apply --include scripts",
  })
end, { desc = "Chezmoi update" })

-- https://nanotipsforvim.prose.sh/repeated-v-in-visual-line-mode
vim.keymap.set("x", "V", "j")

if vim.g.goneovim or vim.g.neovide then
  vim.keymap.set("n", "<C-v>", "a<C-r>+<Esc>")
  vim.keymap.set({ "c", "i" }, "<C-v>", "<C-r>+")
end
