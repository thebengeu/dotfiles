if vim.g.vscode then
  return
end

local util = require("util")

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd.syntax("match", "CR", "/\r$/", "conceal")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.keymap.set("n", "<leader>K", function()
      local node = vim.treesitter.get_node()

      if node and node:type() == "string_content" then
        local node_text = vim.treesitter.get_node_text(node, 0)

        if node_text:match("^[^/]+/[^/]+$") then
          util.open_url("https://github.com/" .. node_text)
          return
        end
      end

      vim.cmd.normal({
        "K",
        bang = true,
      })
    end, { buffer = 0, desc = "Keywordprg" })

    vim.keymap.set("x", "<leader>cL", function()
      local lines = util.visual_lines()

      ---@cast lines -nil
      pcall(
        load(
          table.concat(
            (
              vim.fn.getline(unpack(lines)) --[=[@as string[]]=]
            ),
            "\n"
          )
        ) --[[@as fun(...):...unknown]]
      )
    end, { buffer = 0, desc = "Execute Range" })
  end,
  pattern = "*/lua/*.lua",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local source_or_target = buf_name:match(
      "[/\\]%.local[/\\]share[/\\]chezmoi[/\\]"
    ) and "Target" or "Source"

    if source_or_target == "Target" and not buf_name:match("%.tmpl$") then
      return
    end

    vim.system(
      { "chezmoi", source_or_target:lower() .. "-path", buf_name },
      nil,
      function(system_obj)
        if system_obj.code ~= 0 then
          return
        end

        local path = system_obj.stdout:gsub("\n$", "")

        if
          source_or_target == "Target" and vim.fn.filereadable(path) == 0
          or not buf_name:match("%.tmpl$")
        then
          return
        end

        vim.schedule(function()
          vim.keymap.set("n", "<leader>fc", function()
            vim.cmd.edit(path)
          end, {
            buffer = 0,
            desc = "Chezmoi Edit " .. source_or_target,
          })
        end)
      end
    )
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.keywordprg = ":Man"
  end,
  pattern = "man",
})

if vim.env.TMUX then
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    callback = function()
      vim.system({
        "tmux",
        "rename-window",
        (
          (vim.fn.expand("%:p") --[[@as string]]):gsub(
            vim.uv.os_homedir() or "",
            "~"
          )
        ),
      })
    end,
  })
end
