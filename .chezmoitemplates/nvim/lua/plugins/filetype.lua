local util = require("util")

return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  {
    "alker0/chezmoi.vim",
    config = function()
      local skip_chezmoi_apply

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          local source_path = vim.api.nvim_buf_get_name(0)

          if
            source_path:find("%.chezmoiscripts")
            or source_path:find("ansible")
            or skip_chezmoi_apply
          then
            return
          end

          if source_path:find("%.chezmoidata.cue") then
            util.async_run({ "chezmoi", "apply", "--include", "templates" })
          elseif source_path:find("%.chezmoiexternals%%.cue") then
            util.async_run({ "chezmoi", "apply", "--include", "externals" })
          elseif source_path:find("%.cue") then
            util.async_run({
              "chezmoi",
              "apply",
              "--include",
              "externals,templates",
            })
          elseif source_path:find("%.chezmoitemplates") then
            local chezmoi_source_dir = " ~/.local/share/chezmoi/"
            local app_data_if_windows = jit.os == "Windows"
                and chezmoi_source_dir .. "AppData"
              or ""
            source_path = "$(rg --files-with-matches --glob '*.tmpl' "
              .. source_path:gsub(".*%.chezmoitemplates.", ""):gsub("\\", "/")
              .. app_data_if_windows
              .. chezmoi_source_dir
              .. "dot_config | sort | head -n1)"
            util.async_run_sh("chezmoi apply --source-path " .. source_path)
          elseif source_path:find("%.chezmoi%.yaml%.tmpl") then
            util.async_run({ "chezmoi", "init" })
          elseif source_path:find("chezmoi[/\\]%.") then
            util.async_run({ "chezmoi", "apply" })
          else
            util.async_run({
              "chezmoi",
              "apply",
              "--source-path",
              source_path,
            })
          end
        end,
        pattern = "*/.local/share/chezmoi/*",
      })

      vim.keymap.set("n", "<leader>ua", function()
        skip_chezmoi_apply = not skip_chezmoi_apply
      end, { desc = "Toggle Chezmoi Apply" })
    end,
  },
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    config = true,
    ft = "nu",
  },
  {
    "vuki656/package-info.nvim",
    config = true,
    ft = "json",
  },
  {
    "blankname/vim-fish",
    ft = "fish",
  },
  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },
}
