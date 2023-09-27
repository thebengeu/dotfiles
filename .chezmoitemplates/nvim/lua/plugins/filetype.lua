local async_run = require("util").async_run

return {
  {
    "pearofducks/ansible-vim",
    ft = "yaml.ansible",
  },
  {
    "alker0/chezmoi.vim",
    cond = vim.loop.cwd():find("chezmoi") ~= nil,
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
            async_run({ "chezmoi", "apply", "--include", "templates" })
          elseif source_path:find("%.chezmoiexternal.cue") then
            async_run({ "chezmoi", "apply", "--include", "externals" })
          elseif source_path:find("%.cue") then
            async_run({ "chezmoi", "apply", "--include", "externals,templates" })
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
            async_run({
              "sh",
              "-c",
              "chezmoi apply --source-path " .. source_path,
            })
          elseif source_path:find("%.chezmoi%.yaml%.tmpl") then
            async_run({ "chezmoi", "init" })
          elseif source_path:find("chezmoi[/\\]%.") then
            async_run({ "chezmoi", "apply" })
          else
            async_run({
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

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local source_or_target = buf_name:find(
            "[/\\]%.local[/\\]share[/\\]chezmoi[/\\]"
          ) and "Target" or "Source"

          if source_or_target == "Target" and not buf_name:find("%.tmpl$") then
            return
          end

          vim.system(
            { "chezmoi", source_or_target:lower() .. "-path", buf_name },
            nil,
            function(system_obj)
              if system_obj.code ~= 0 then
                return
              end

              local path = system_obj.stdout:gsub("\n", "")

              if
                source_or_target == "Target"
                  and vim.fn.filereadable(path) == 0
                or not buf_name:find("%.tmpl$")
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
