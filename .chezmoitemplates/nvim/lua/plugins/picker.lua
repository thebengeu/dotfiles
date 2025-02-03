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

    require("telescope.builtin")["git_" .. picker]({
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
            "--pretty=%Cgreen%ah%Creset %aN%n%n%B",
            entry.value,
          }, is_bcommits and { "--", entry.current_file } or {})
        end,
      }),
    })
  end
end

local egrepify = function(cwd, grep_word, vimgrep_arguments)
  return function()
    local visual = Snacks.picker.util.visual()
    local default_text = visual and visual.text
      or (grep_word and vim.fn.expand("<cword>"))

    require("telescope").extensions.egrepify.egrepify({
      cwd = cwd == nil and LazyVim.root() or cwd,
      default_text = default_text,
      vimgrep_arguments = vimgrep_arguments
          and vim.list_extend(
            vim.fn.copy(require("telescope.config").values.vimgrep_arguments),
            vimgrep_arguments
          )
        or nil,
    })
  end
end

local get_directory = function(picker_name, cwd)
  return function()
    cwd = cwd or vim.uv.cwd()
    local visual = Snacks.picker.util.visual()

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
              if picker_name == "smart_files" then
                util.smart_files({
                  cwd = cwd .. "/" .. selected_entry_value,
                })()
                return
              end

              table.insert(search_dirs, selected_entry_value)
            else
              for _, selection in ipairs(multi_selection) do
                table.insert(search_dirs, selection.value)
              end
            end

            require("telescope").extensions.egrepify.egrepify({
              cwd = cwd,
              default_text = visual and visual.text,
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
        previewer = require("telescope.previewers").new_termopen_previewer({
          get_command = function(entry)
            return {
              "eza",
              "--all",
              "--git",
              "--group-directories-first",
              "--icons",
              "--long",
              "--no-user",
              cwd .. "/" .. entry.value,
            }
          end,
        }),
        sorter = require("telescope.config").values.file_sorter(),
      })
      :find()
  end
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false },
      {
        "<leader><space>",
        util.smart_files({
          multi = { "buffers", "files" },
        }),
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fa",
        util.smart_files({ cwd = lazy_root .. "/snacks.nvim" }),
        desc = "Find snacks.nvim Files",
      },
      {
        "<leader>fc",
        util.smart_files({
          cwd = "~/.local/share/chezmoi/.chezmoitemplates/nvim",
        }),
        desc = "Find Config File",
      },
      {
        "<leader>fF",
        get_directory("smart_files"),
        desc = "Find Files (subdirs)",
      },
      {
        "<leader>ff",
        function()
          util.smart_files({ cwd = LazyVim.root() })()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fi",
        util.smart_files({ ignored = true }),
        desc = "Find Files (ignored)",
      },
      {
        "<leader>fl",
        util.smart_files({ cwd = lazy_root .. "/LazyVim" }),
        desc = "Find LazyVim Files",
      },
      {
        "<leader>fP",
        util.smart_files({ cwd = lazy_root }),
        desc = "Find Plugin Files",
      },
      {
        "<leader>fp",
        get_directory("smart_files", lazy_root),
        desc = "Find Plugin's Files",
      },
      { "<leader>gc", false },
      { "<leader>gs", false },
      {
        "<leader>sA",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      { "<leader>sa", false },
      { "<leader>sG", false },
      { "<leader>sg", false },
      { "<leader>sl", false },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sW", false },
      { "<leader>sw", false },
    },
    opts = {
      picker = {
        formatters = {
          file = {
            filename_first = true,
          },
        },
        hidden = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
          preview = {
            minimal = true,
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>gf",
        delta_diffview_git_picker("bcommits"),
        desc = "Git Current File History",
      },
      {
        "<leader>gf",
        delta_diffview_git_picker("bcommits_range"),
        desc = "Git Current File History",
        mode = "x",
      },
      {
        "<leader>gc",
        delta_diffview_git_picker("commits"),
        desc = "Git Log",
      },
      {
        "<leader>gm",
        function()
          local root = LazyVim.root()

          vim
            .system({ "git", "add", "--intent-to-add", "." }, { cwd = root })
            :wait()

          local default_branch = util.git_stdout({ "default-branch" })
          local current_branch = util.git_stdout({ "branch", "--show-current" })
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
        function()
          require("telescope.builtin").git_branches({
            show_remote_tracking_branches = false,
          })
        end,
        desc = "Branches",
      },
      {
        "<leader>gs",
        function()
          local root = LazyVim.root()

          require("telescope.builtin").git_status({
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
          })
        end,
        desc = "Status",
      },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")

      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function()
          vim.wo.wrap = true
        end,
      })

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        layout_config = {
          flex = {
            flip_columns = 160,
          },
          horizontal = {
            height = 0.95,
            width = 0.95,
            preview_width = 0.5,
          },
          vertical = {
            height = 0.95,
            width = 0.95,
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
        winblend = 5,
      })

      local vertical_undo = vim.o.columns > 160

      opts.extensions = {
        file_browser = {
          follow_symlinks = true,
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
        egrepify(false),
        desc = "Grep (cwd)",
        mode = { "n", "x" },
      },
      {
        "<leader>sa",
        egrepify(lazy_root .. "/snacks.nvim"),
        desc = "Grep snacks.nvim",
        mode = { "n", "x" },
      },
      {
        "<leader>sG",
        get_directory("egrepify"),
        desc = "Grep (subdirs)",
        mode = { "n", "x" },
      },
      {
        "<leader>sg",
        egrepify(),
        desc = "Grep (Root Dir)",
        mode = { "n", "x" },
      },
      {
        "<leader>sI",
        egrepify(nil, nil, { "--no-ignore" }),
        desc = "Grep (ignored)",
        mode = { "n", "x" },
      },
      {
        "<leader>sl",
        egrepify(lazy_root .. "/LazyVim"),
        desc = "Grep LazyVim",
        mode = { "n", "x" },
      },
      {
        "<leader>sP",
        egrepify(lazy_root),
        desc = "Grep Plugins",
        mode = { "n", "x" },
      },
      {
        "<leader>sp",
        get_directory("egrepify", lazy_root),
        desc = "Grep Plugin",
        mode = { "n", "x" },
      },
      {
        "<leader>sW",
        egrepify(false, true),
        desc = "Visual selection or word (cwd)",
        mode = { "n", "x" },
      },
      {
        "<leader>sw",
        egrepify(nil, true),
        desc = "Visual selection or word (Root Dir)",
        mode = { "n", "x" },
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
        "<leader>sU",
        function()
          require("telescope").extensions.undo.undo()
        end,
        desc = "Undo",
      },
    },
  },
}
