local LazyVim = require("lazyvim.util")
local util = require("util")

local lazy_root = require("lazy.core.config").options.root

local delta_diffview_git_picker = function(picker)
  return function()
    local is_bcommits = picker:match("bcommits")
    local root = LazyVim.root()

    local displayer = require("telescope.pickers.entry_display").create({
      separator = " ",
      items = {
        { width = 15 },
        { remaining = true },
      },
    })

    local make_display = function(entry)
      local date, msg = entry.msg:match("([^|]+)|(.+)")

      return displayer({
        { date, "TelescopeResultsIdentifier" },
        msg,
      })
    end

    LazyVim.telescope("git_" .. picker, {
      attach_mappings = function()
        local actions = require("telescope.actions")

        actions.select_default:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local entry = require("telescope.actions.state").get_selected_entry()
          vim.cmd.DiffviewOpen(
            entry.value
              .. "^!"
              .. (is_bcommits and (" -- " .. entry.current_file) or "")
          )
        end)

        return true
      end,
      entry_index = {
        display = function()
          return make_display, true
        end,
      },
      git_command = vim.list_extend(
        {
          "git",
          "log",
          "--pretty=%h %ah|%s",
        },
        picker == "bcommits" and { "--follow" }
          or (
            picker == "bcommits_range" and { "--no-patch", "-L" }
            or {
              "--",
              ".",
            }
          )
      ),
      previewer = require("telescope.previewers").new_termopen_previewer({
        cwd = root,
        get_command = function(entry)
          return vim.list_extend({
            "git",
            "show",
            "--pretty=format:%Cgreen%ah%Creset %aN%n%n%B",
            entry.value,
          }, is_bcommits and { "--", entry.current_file } or {})
        end,
      }),
    })()
  end
end

local egrepify = function(cwd, vimgrep_arguments)
  return function()
    require("telescope").extensions.egrepify.egrepify({
      cwd = cwd == nil and LazyVim.root() or cwd,
      vimgrep_arguments = vimgrep_arguments
          and vim.list_extend(
            vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
            vimgrep_arguments
          )
        or nil,
    })
  end
end

local smart_open = function(cwd)
  return function()
    require("telescope").extensions.smart_open.smart_open({
      cwd = cwd == nil and LazyVim.root() or cwd,
    })
  end
end

local get_directory = function(picker_name, cwd)
  return function()
    cwd = cwd or vim.loop.cwd()

    require("telescope.pickers")
      .new({}, {
        attach_mappings = function(prompt_bufnr)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          actions.select_default:replace(function()
            local selected_entry_value = action_state.get_selected_entry().value
            local multi_selection = action_state
              .get_current_picker(prompt_bufnr)
              :get_multi_selection()
            local search_dirs = {}

            actions.close(prompt_bufnr)

            if vim.tbl_isempty(multi_selection) then
              if picker_name == "find_files" then
                require("telescope").extensions.smart_open.smart_open({
                  cwd = cwd .. "/" .. selected_entry_value,
                })
                return
              end

              table.insert(search_dirs, selected_entry_value)
            else
              for _, selection in ipairs(multi_selection) do
                table.insert(search_dirs, selection.value)
              end
            end

            (
              picker_name == "egrepify"
                and require("telescope").extensions.egrepify.egrepify
              or require("telescope.builtin")[picker_name]
            )({
              cwd = cwd,
              search_dirs = search_dirs,
            })
          end)
          return true
        end,
        finder = require("telescope.finders").new_oneshot_job({
          "fd",
          "--follow",
          "--max-depth",
          "1",
          "--type",
          "directory",
        }, {
          cwd = cwd,
          entry_maker = require("telescope.make_entry").gen_from_file({
            cwd = cwd,
          }),
        }),
        sorter = require("telescope.config").values.file_sorter(),
      })
      :find()
  end
end

return {
  {
    "thebengeu/smart-open.nvim",
    dependencies = "kkharji/sqlite.lua",
    keys = {
      {
        "<leader><space>",
        smart_open(),
        desc = "Find Files (root dir)",
      },
      {
        "<leader>fc",
        smart_open("~/.local/share/chezmoi/.chezmoitemplates/nvim"),
        desc = "Find Config File",
      },
      {
        "<leader>fF",
        get_directory("find_files"),
        desc = "Find Files (subdirs)",
      },
      {
        "<leader>ff",
        smart_open(false),
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fl",
        smart_open(lazy_root .. "/LazyVim"),
        desc = "Find LazyVim Files",
      },
      {
        "<leader>fP",
        smart_open(lazy_root),
        desc = "Find Plugin Files",
      },
      {
        "<leader>fp",
        get_directory("find_files", lazy_root),
        desc = "Find Plugin's Files",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = false,
      },
      {
        "nvim-telescope/telescope-fzy-native.nvim",
        config = function()
          LazyVim.on_load("telescope.nvim", function()
            require("telescope").load_extension("fzy_native")
          end)
        end,
      },
    },
    keys = function(_, keys)
      vim.list_extend(keys, {
        { "<leader>/", false },
        { "<leader><space>", false },
        { "<leader>fc", false },
        { "<leader>fF", false },
        { "<leader>ff", false },
        {
          "<leader>fi",
          LazyVim.telescope("find_files", { no_ignore = true }),
          desc = "Find Files (ignored)",
        },
        {
          "<leader>fR",
          LazyVim.telescope("oldfiles", { cwd = false }),
          desc = "Recent",
        },
        {
          "<leader>fr",
          LazyVim.telescope("oldfiles"),
          desc = "Recent (root dir)",
        },
        {
          "<leader>gb",
          LazyVim.telescope(
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
          "<leader>gm",
          function()
            local root = LazyVim.root()

            vim
              .system({ "git", "add", "--intent-to-add", "." }, { cwd = root })
              :wait()

            local default_branch = util.git_stdout({ "default-branch" })
            local current_branch =
              util.git_stdout({ "branch", "--show-current" })
            local git_diff_commit = current_branch == default_branch
                and (util.git_stdout({
                  "rev-parse",
                  "HEAD",
                }) == util.git_stdout({
                  "rev-parse",
                  "@{u}",
                }) and (#util.git_stdout({
                  "status",
                  "--short",
                }) > 0 and "HEAD" or "HEAD^") or "origin/HEAD")
              or (default_branch .. "...")

            require("telescope.pickers")
              .new({}, {
                finder = require("telescope.finders").new_oneshot_job({
                  "git",
                  "diff",
                  "--diff-filter=d",
                  "--name-only",
                  git_diff_commit,
                }, {
                  cwd = root,
                  entry_maker = require("telescope.make_entry").gen_from_file({
                    cwd = root,
                  }),
                }),
                previewer = require("telescope.previewers").new_termopen_previewer({
                  cwd = root,
                  get_command = function(entry)
                    return {
                      "sh",
                      "-c",
                      "git diff "
                        .. git_diff_commit
                        .. " -- "
                        .. entry.value
                        .. " | delta | tail -n +5",
                    }
                  end,
                }),
                prompt_title = "Changed Files Against " .. git_diff_commit,
                sorter = require("telescope.config").values.file_sorter(),
              })
              :find()
          end,
          desc = "Changed Files",
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
            local root = LazyVim.root()

            LazyVim.telescope("git_status", {
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
        { "<leader>sG", false },
        { "<leader>sg", false },
        { "<leader>sR", false },
        { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
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

      local vertical_undo = vim.o.columns > 160

      opts.extensions = {
        file_browser = {
          follow_symlinks = true,
        },
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },
        smart_open = {
          cwd_only = true,
        },
        undo = vim.tbl_extend("force", {
          diff_context_lines = 5,
          use_custom_command = {
            "sh",
            "-c",
            "echo '$DIFF' | delta"
              .. (vertical_undo and " --side-by-side" or ""),
          },
        }, vertical_undo and {
          layout_config = {
            preview_height = 0.7,
          },
          layout_strategy = "vertical",
        } or {}),
      }
    end,
  },
  {
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<leader>/",
        egrepify(),
        desc = "Grep (root dir)",
      },
      {
        "<leader>sG",
        get_directory("egrepify"),
        desc = "Grep (subdirs)",
      },
      {
        "<leader>sg",
        egrepify(false),
        desc = "Grep (cwd)",
      },
      {
        "<leader>si",
        egrepify(nil, { "--no-ignore" }),
        desc = "Grep (root dir ignored)",
      },
      {
        "<leader>sI",
        egrepify(false, { "--no-ignore" }),
        desc = "Grep (cwd ignored)",
      },
      {
        "<leader>sl",
        egrepify(lazy_root .. "/LazyVim"),
        desc = "Grep LazyVim",
      },
      {
        "<leader>sP",
        egrepify(lazy_root),
        desc = "Grep Plugins",
      },
      {
        "<leader>sp",
        get_directory("egrepify", lazy_root),
        desc = "Grep Plugin",
      },
    },
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
