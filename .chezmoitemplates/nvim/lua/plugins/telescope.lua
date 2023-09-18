local Util = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzy-native.nvim",
      config = function()
        require("telescope").load_extension("fzy_native")
      end,
    },
    keys = function(_, keys)
      vim.list_extend(keys, {
        {
          "<leader>/",
          Util.telescope("live_grep", { cwd = false }),
          desc = "Grep (cwd)",
        },
        { "<leader><space>", false },
        {
          "<leader>fF",
          Util.telescope("find_files"),
          desc = "Find Files (root dir)",
        },
        {
          "<leader>ff",
          Util.telescope("find_files", { cwd = false }),
          desc = "Find Files (cwd)",
        },
        {
          "<leader>fi",
          function()
            require("telescope.builtin").find_files({ no_ignore = true })
          end,
          desc = "Find Files (ignored)",
        },
        {
          "<leader>fp",
          function()
            require("telescope.builtin").find_files({
              cwd = require("lazy.core.config").options.root,
            })
          end,
          desc = "Find Plugin Files",
        },
        {
          "<leader>gb",
          "<Cmd>Telescope git_bcommits<CR>",
          desc = "Buffer commits",
        },
        { "<leader>gC", "<Cmd>Telescope git_commits<CR>", desc = "Commits" },
        { "<leader>gc" },
        {
          "<leader>gr",
          "<Cmd>Telescope git_bcommits_range<CR>",
          desc = "Range commits",
          mode = "x",
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
          function()
            local root = require("lazy.core.config").options.root
            require("telescope.pickers")
              .new({}, {
                attach_mappings = function(prompt_bufnr)
                  local actions = require("telescope.actions")
                  actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection =
                      require("telescope.actions.state").get_selected_entry()
                    require("telescope.builtin").live_grep({
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
          end,
          desc = "Grep Plugin Folder",
        },
      })
    end,
    opts = function(_, opts)
      opts.defaults = vim.tbl_extend("force", opts.defaults, {
        layout_config = {
          flex = {
            flip_columns = 120,
          },
        },
        layout_strategy = "flex",
        vimgrep_arguments = vim.list_extend(
          vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
          { "--hidden" }
        ),
        winblend = 5,
      })
      opts.extensions = {
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },
      }
    end,
  },
}
