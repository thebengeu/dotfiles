local Util = require("lazyvim.util")
local util = require("util")

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
        return function()
          local is_bcommits = picker:match("bcommits")
          local root = Util.root()

          Util.telescope("git_" .. picker, {
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
                  { "git", "-C", root, "diff", entry.value .. "^!" },
                  is_bcommits and { "--", entry.current_file } or {}
                )
              end,
            }),
          })()
        end
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
                  Util.telescope(
                    telescope_builtin,
                    { cwd = root .. "/" .. selection[1] }
                  )()
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
          "<leader><space>",
          Util.telescope("find_files"),
          desc = "Find Files (root dir)",
        },
        {
          "<leader>fc",
          Util.telescope(
            "find_files",
            { cwd = "~/.local/share/chezmoi/.chezmoitemplates/nvim" }
          ),
          desc = "Find Config File",
        },
        {
          "<leader>ff",
          Util.telescope("find_files", {
            cwd = false,
            follow = true,
          }),
          desc = "Find Files (cwd)",
        },
        { "<leader>fF", false },
        {
          "<leader>fl",
          Util.telescope("find_files", {
            cwd = require("lazy.core.config").options.root .. "/LazyVim",
          }),
          desc = "Find LazyVim Files",
        },
        {
          "<leader>fi",
          Util.telescope("find_files", { no_ignore = true }),
          desc = "Find Files (ignored)",
        },
        {
          "<leader>fP",
          Util.telescope("find_files", {
            cwd = require("lazy.core.config").options.root,
          }),
          desc = "Find Plugin Files",
        },
        {
          "<leader>fp",
          get_plugin_folder("find_files"),
          desc = "Find Plugin's Files",
        },
        {
          "<leader>fR",
          Util.telescope("oldfiles", { cwd = false }),
          desc = "Recent",
        },
        {
          "<leader>fr",
          Util.telescope("oldfiles"),
          desc = "Recent (root dir)",
        },
        {
          "<leader>gb",
          Util.telescope(
            "git_branches",
            { show_remote_tracking_branches = false }
          ),
          desc = "Branches",
        },
        {
          "<leader>gC",
          delta_diffview_git_picker("bcommits"),
          desc = "Buffer commits",
        },
        {
          "<leader>gc",
          delta_diffview_git_picker("commits"),
          desc = "Commits",
        },
        {
          "<leader>gr",
          delta_diffview_git_picker("bcommits_range"),
          desc = "Range commits",
          mode = "x",
        },
        {
          "<leader>gs",
          function()
            local root = Util.root()

            Util.telescope("git_status", {
              previewer = require("telescope.previewers").new_termopen_previewer({
                get_command = function(entry)
                  if
                    entry.status
                    and (entry.status == "??" or entry.status == "A ")
                  then
                    return { "bat", "--plain", entry.value }
                  else
                    return {
                      "git",
                      "-C",
                      root,
                      "diff",
                      "HEAD",
                      "--",
                      entry.value,
                    }
                  end
                end,
              }),
            })()
          end,
          desc = "Status",
        },
        {
          "<leader>sg",
          Util.telescope("live_grep", {
            cwd = false,
          }),
          desc = "Grep (cwd)",
        },
        { "<leader>sG", false },
        {
          "<leader>si",
          Util.telescope("live_grep", {
            additional_args = { "--no-ignore" },
          }),
          desc = "Grep (root dir ignored)",
        },
        {
          "<leader>sI",
          Util.telescope("live_grep", {
            additional_args = { "--no-ignore" },
            cwd = false,
          }),
          desc = "Grep (cwd ignored)",
        },
        {
          "<leader>sl",
          Util.telescope("live_grep", {
            cwd = require("lazy.core.config").options.root .. "/LazyVim",
          }),
          desc = "Grep LazyVim",
        },
        {
          "<leader>sP",
          Util.telescope("live_grep", {
            cwd = require("lazy.core.config").options.root,
          }),
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

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
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
          { "--follow", "--hidden" }
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
}
