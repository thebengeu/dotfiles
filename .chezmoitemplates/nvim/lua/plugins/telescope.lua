local Util = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = "kkharji/sqlite.lua",
        opts = {
          pickers = {
            git_commits = {
              disable = true,
            },
          },
        },
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = false,
      },
      {
        "nvim-telescope/telescope-fzy-native.nvim",
        config = function()
          Util.on_load("telescope.nvim", function()
            require("telescope").load_extension("fzy_native")
          end)
        end,
      },
    },
    keys = function(_, keys)
      local delta_diffview_git_picker = function(picker)
        local is_bcommits = picker:match("bcommits")

        require("telescope.builtin")["git_" .. picker]({
          attach_mappings = function()
            local actions = require("telescope.actions")

            actions.select_default:replace(function(prompt_bufnr)
              actions.close(prompt_bufnr)
              local entry =
                require("telescope.actions.state").get_selected_entry()
              vim.cmd.DiffviewOpen(
                entry.value
                  .. "^!"
                  .. (is_bcommits and (" -- " .. entry.current_file) or "")
              )
            end)

            return true
          end,
          previewer = require("telescope.previewers").new_termopen_previewer({
            get_command = function(entry)
              return vim.list_extend(
                { "git", "diff", entry.value .. "^!" },
                is_bcommits and { "--", entry.current_file } or {}
              )
            end,
          }),
        })
      end

      local get_plugin_folder = function(telescope_builtin)
        return function()
          local root = require("lazy.core.config").options.root
          require("telescope.pickers")
            .new({}, {
              attach_mappings = function(prompt_bufnr)
                local actions = require("telescope.actions")
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection =
                    require("telescope.actions.state").get_selected_entry()
                  require("telescope.builtin")[telescope_builtin]({
                    cwd = root .. "/" .. selection[1],
                  })
                end)
                return true
              end,
              finder = require("telescope.finders").new_table({
                results = vim.fn.readdir(root),
              }),
              sorter = require("telescope.config").values.file_sorter(),
            })
            :find()
        end
      end

      vim.list_extend(keys, {
        {
          "<leader>/",
          Util.telescope("live_grep", { cwd = false }),
          desc = "Grep (cwd)",
        },
        {
          "<leader><space>",
          Util.telescope("find_files", { cwd = false }),
          desc = "Find Files (cwd)",
        },
        {
          "<leader>fF",
          Util.telescope("find_files", { cwd = false }),
          desc = "Find Files (cwd)",
        },
        {
          "<leader>ff",
          Util.telescope("find_files"),
          desc = "Find Files (root dir)",
        },
        {
          "<leader>fl",
          function()
            require("telescope.builtin").find_files({
              cwd = require("lazy.core.config").options.root .. "/LazyVim",
            })
          end,
          desc = "Find LazyVim Files",
        },
        {
          "<leader>fi",
          function()
            require("telescope.builtin").find_files({ no_ignore = true })
          end,
          desc = "Find Files (ignored)",
        },
        {
          "<leader>fP",
          function()
            require("telescope.builtin").find_files({
              cwd = require("lazy.core.config").options.root,
            })
          end,
          desc = "Find Plugin Files",
        },
        {
          "<leader>fp",
          get_plugin_folder("find_files"),
          desc = "Find Plugin's Files",
        },
        {
          "<leader>gb",
          function()
            delta_diffview_git_picker("bcommits")
          end,
          desc = "Buffer commits",
        },
        {
          "<leader>gc",
          function()
            delta_diffview_git_picker("commits")
          end,
          desc = "Commits",
        },
        {
          "<leader>gr",
          function()
            delta_diffview_git_picker("bcommits_range")
          end,
          desc = "Range commits",
          mode = "x",
        },
        {
          "<leader>gs",
          function()
            require("telescope.builtin").git_status({
              previewer = require("telescope.previewers").new_termopen_previewer({
                get_command = function(entry)
                  if
                    entry.status
                    and (entry.status == "??" or entry.status == "A ")
                  then
                    return { "bat", "--plain", entry.value }
                  else
                    return { "git", "diff", "HEAD", "--", entry.value }
                  end
                end,
              }),
            })
          end,
          desc = "Status",
        },
        {
          "<leader>si",
          function()
            Util.telescope("live_grep", {
              vimgrep_arguments = vim.list_extend(
                vim.fn.copy(
                  require("telescope.config").values.vimgrep_arguments
                ),
                { "--no-ignore" }
              ),
            })()
          end,
          desc = "Grep (root dir ignored)",
        },
        {
          "<leader>sI",
          function()
            Util.telescope("live_grep", {
              cwd = false,
              vimgrep_arguments = vim.list_extend(
                vim.fn.copy(
                  require("telescope.config").values.vimgrep_arguments
                ),
                { "--no-ignore" }
              ),
            })()
          end,
          desc = "Grep (cwd ignored)",
        },
        {
          "<leader>sl",
          function()
            require("telescope.builtin").live_grep({
              cwd = require("lazy.core.config").options.root .. "/LazyVim",
            })
          end,
          desc = "Grep LazyVim",
        },
        {
          "<leader>sP",
          function()
            require("telescope.builtin").live_grep({
              cwd = require("lazy.core.config").options.root,
            })
          end,
          desc = "Grep Plugins",
        },
        {
          "<leader>sp",
          get_plugin_folder("live_grep"),
          desc = "Grep Plugin",
        },
      })
    end,
    opts = function(_, opts)
      local actions = require("telescope.actions")

      opts.defaults = vim.tbl_extend("force", opts.defaults, {
        layout_config = {
          flex = {
            flip_columns = 160,
          },
        },
        layout_strategy = "flex",
        mappings = {
          i = {
            ["<C-a>"] = actions.cycle_previewers_prev,
            ["<C-s>"] = actions.cycle_previewers_next,
            ["<Esc>"] = actions.close,
          },
        },
        vimgrep_arguments = vim.list_extend(
          vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
          { "--hidden" }
        ),
        winblend = 5,
      })

      local undo_opts = {
        diff_context_lines = 5,
        use_custom_command = {
          "sh",
          "-c",
          "echo '$DIFF' | delta",
        },
      }

      if vim.o.columns > 160 then
        undo_opts.layout_config = {
          preview_height = 0.7,
        }
        undo_opts.layout_strategy = "vertical"
        undo_opts.use_custom_command[3] = undo_opts.use_custom_command[3]
          .. " --side-by-side"
      end

      opts.extensions = {
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },
        undo = undo_opts,
      }
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<leader>fb",
        function()
          require("telescope").extensions.file_browser.file_browser()
        end,
        desc = "File Browser",
      },
    },
    {
      "debugloop/telescope-undo.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      keys = {
        {
          "<leader>su",
          function()
            require("telescope").extensions.undo.undo()
          end,
          desc = "Undo",
        },
      },
    },
  },
}
