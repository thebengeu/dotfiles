local LazyVim = require("lazyvim.util")
local util = require("util")

local lazy_root = require("lazy.core.config").options.root

local M = {}

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
      git_command = {
        "git",
        "log",
        "--pretty=%h %ah|%s",
        unpack(
          picker == "bcommits" and { "--follow" }
            or (
              picker == "bcommits_range" and { "--no-patch", "-L" }
              or {
                "--",
                ".",
              }
            )
        ),
      },
      previewer = require("telescope.previewers").new_termopen_previewer({
        cwd = root,
        get_command = function(entry)
          return {
            "git",
            "show",
            "--pretty=%Cgreen%ah%Creset %aN%n%n%B",
            entry.value,
            unpack(is_bcommits and { "--", entry.current_file } or {}),
          }
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
      vimgrep_arguments = {
        unpack(require("telescope.config").values.vimgrep_arguments),
        unpack(vimgrep_arguments or {}),
      },
    })
  end
end

local colorscheme_dirs = vim
  .iter(require("plugins.colorscheme"))
  :map(function(spec)
    local suffix = (spec.name or spec[1]):gsub("^.*/", "")
    return suffix
  end)
  :totable()

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false },
      {
        "<leader><space>",
        util.smart({ multi = { "buffers", "files" } }),
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fa",
        util.smart({ cwd = lazy_root .. "/snacks.nvim" }),
        desc = "Find snacks.nvim Files",
      },
      {
        "<leader>fc",
        util.smart({ cwd = "~/.local/share/chezmoi/.chezmoitemplates/nvim" }),
        desc = "Find Config File",
      },
      {
        "<leader>fF",
        util.get_directory("smart"),
        desc = "Find Files (subdirs)",
      },
      {
        "<leader>ff",
        function()
          util.smart({ cwd = LazyVim.root() })()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fi",
        util.smart({ ignored = true }),
        desc = "Find Files (ignored)",
      },
      {
        "<leader>fL",
        util.smart({ cwd = lazy_root }),
        desc = "Find Plugin Files",
      },
      {
        "<leader>fl",
        util.get_directory("smart", lazy_root, colorscheme_dirs),
        desc = "Find Plugin's Files",
      },
      {
        "<leader>fS",
        util.get_directory("smart", lazy_root, nil, colorscheme_dirs),
        desc = "Find Colorscheme's Files",
      },
      {
        "<leader>fv",
        util.smart({ cwd = lazy_root .. "/LazyVim" }),
        desc = "Find LazyVim Files",
      },
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
      { "<leader>sW", false },
      { "<leader>sw", false },
    },
    opts = {
      picker = {
        formatters = {
          file = {
            filename_first = true,
            icon_width = 2,
            truncate = 100,
          },
        },
        layouts = {
          default = {
            layout = {
              width = 0.95,
              height = 0.95,
            },
          },
        },
        previewers = {
          diff = {
            builtin = false,
          },
          git = {
            builtin = false,
          },
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          smart = {
            follow = true,
            hidden = true,
            multi = { "files" },
          },
        },
        win = {
          input = {
            keys = {
              ["<C-/>"] = { "toggle_help_list", mode = { "i", "n" } },
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
      { "<leader>se", "<cmd>Telescope resume<cr>", desc = "Resume" },
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
        "<leader>gw",
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

      local flash = function(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
                  ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker =
              require("telescope.actions.state").get_current_picker(
                prompt_bufnr
              )
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end

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
          prompt_position = "top",
          vertical = {
            height = 0.95,
            width = 0.95,
          },
        },
        layout_strategy = "flex",
        mappings = {
          i = {
            ["<A-t>"] = open_with_trouble,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Left>"] = actions.cycle_previewers_prev,
            ["<C-Right>"] = actions.cycle_previewers_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-s>"] = flash,
            ["<C-t>"] = open_with_trouble,
          },
          n = {
            s = flash,
          },
        },
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        winblend = 10,
      })
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
        util.get_directory("egrepify"),
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
        "<leader>sL",
        egrepify(lazy_root),
        desc = "Grep Plugins",
        mode = { "n", "x" },
      },
      {
        "<leader>sl",
        util.get_directory("egrepify", lazy_root),
        desc = "Grep Plugin",
        mode = { "n", "x" },
      },
      {
        "<leader>sv",
        egrepify(lazy_root .. "/LazyVim"),
        desc = "Grep LazyVim",
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
}
