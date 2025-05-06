local LazyVim = require("lazyvim.util")
local colorscheme_specs = require("plugins.colorscheme")
local util = require("util")

local colorschemes
local max_colorscheme_name_length

local get_colorscheme_name = function(colorscheme)
  return table.concat(colorscheme, "-"):gsub(" ", "_"):gsub("-lighte?r?", "")
end

local refresh_colorschemes = function()
  colorschemes = {}

  for _, spec in ipairs(colorscheme_specs) do
    local name = util.normname(spec.name or spec[1])
    local extra_spec = util.extra_specs[name] or {}
    local insert_non_light = extra_spec.supports_light_background
      or vim.o.background ~= "light"
    local colors_names =
      extra_spec["colors_names" .. (insert_non_light and "" or "_light")]

    if colors_names then
      for _, colors_name in ipairs(colors_names) do
        table.insert(colorschemes, { colors_name })
        util.highlights[colors_name] = extra_spec.highlights
      end
    else
      util.highlights[name] = extra_spec.highlights

      if extra_spec.colorscheme_styles then
        for _, colorscheme_style in ipairs(extra_spec.colorscheme_styles) do
          if
            colorscheme_style:match("light") or colorscheme_style == "summer"
          then
            if vim.o.background == "light" then
              table.insert(colorschemes, { name, colorscheme_style })
            end
          elseif insert_non_light then
            table.insert(colorschemes, { name, colorscheme_style })
          end
        end
      elseif insert_non_light then
        table.insert(colorschemes, { name })
      end
    end
  end

  max_colorscheme_name_length = 0

  for _, colorscheme in ipairs(colorschemes) do
    max_colorscheme_name_length =
      math.max(#get_colorscheme_name(colorscheme), max_colorscheme_name_length)
  end
end

local bg
local colorscheme_index

local set_background = function()
  if bg then
    if vim.env.KITTY_WINDOW_ID then
      vim.system({ "kitten", "@", "set-colors", "background=#" .. bg })
    else
      util.wezterm_set_user_var("BACKGROUND", bg)
    end
  end
end

math.randomseed(os.time())

local refresh_colorscheme = function(index)
  colorscheme_index = (index and index >= 1 and index <= #colorschemes)
      and index
    or math.random(#colorschemes)
  local name, style = unpack(colorschemes[colorscheme_index])

  util.colorscheme_style = style

  if style then
    local extra_spec = util.extra_specs[name]

    if extra_spec.colorscheme_style_key then
      local theme = {
        [extra_spec.colorscheme_style_key] = style,
      }

      require(name).setup(
        vim.tbl_extend(
          "error",
          extra_spec.opts or {},
          name == "evergarden" and { theme = theme } or theme
        )
      )
    else
      vim.g[name:gsub("-", "_") .. "_" .. (extra_spec.colorscheme_style_suffix or "style")] =
        style
    end
  end

  vim.g.transparent_enabled = false
  vim.g.colors_name = name
  vim.cmd.colorscheme(name)

  if name == "newpaper" then
    vim.cmd["Newpaper" .. (style == "light" and "Light" or "Dark")]()
  end

  bg = string.format("%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg)

  set_background()
  require("transparent").toggle(true)

  vim.schedule(function()
    require("lualine").refresh()
  end)
end

vim.api.nvim_create_autocmd("FocusGained", {
  callback = set_background,
})

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    util.wezterm_set_user_var("BACKGROUND", "")
  end,
})

local background_path = vim.fn.stdpath("data") .. "/background"
local colorscheme_index_path = vim.fn.stdpath("data") .. "/colorscheme_index"

local randomize_colorscheme = function()
  os.remove(colorscheme_index_path)
  refresh_colorscheme()
end

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymapsDefaults",
  callback = function()
    Snacks.toggle({
      name = "Dark Background",
      get = function()
        return vim.o.background == "dark"
      end,
      set = function(state)
        vim.opt.background = state and "dark" or "light"

        local file = io.open(background_path, "w")

        if file then
          file:write(vim.o.background, "\n")
          file:close()
        end

        refresh_colorschemes()
        randomize_colorscheme()
      end,
    }):map("<leader>ub")

    Snacks.toggle({
      name = "Randomize Colorscheme",
      get = function()
        return vim.fn.filereadable(colorscheme_index_path) == 0
      end,
      set = function(state)
        if state then
          randomize_colorscheme()
        else
          local file = io.open(colorscheme_index_path, "w")

          if file then
            file:write(colorscheme_index, "\n")
            file:close()
          end
        end
      end,
    }):map("<leader>uR")
  end,
})

vim.keymap.set("n", "[S", function()
  refresh_colorscheme(
    colorscheme_index == 1 and #colorschemes or colorscheme_index - 1
  )
end, { desc = "Colorscheme backward" })

vim.keymap.set("n", "]S", function()
  refresh_colorscheme(
    colorscheme_index == #colorschemes and 1 or colorscheme_index + 1
  )
end, { desc = "Colorscheme forward" })

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local background_file = io.open(background_path)

        if background_file then
          vim.opt.background = background_file:read("l")
          background_file:close()
        end

        local index
        local colorscheme_index_file = io.open(colorscheme_index_path)

        if colorscheme_index_file then
          index = colorscheme_index_file:read("n")
          colorscheme_index_file:close()
        end

        refresh_colorschemes()
        refresh_colorscheme(index)
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] =
        { LazyVim.lualine.pretty_path({ length = 4 }) }
      opts.sections.lualine_z = {
        function()
          return get_colorscheme_name(colorschemes[colorscheme_index])
        end,
      }
    end,
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>uC",
        function()
          local actions = require("telescope.actions")
          local action_set = require("telescope.actions.set")
          local actions_state = require("telescope.actions.state")

          require("telescope.pickers")
            .new({ sorting_strategy = "ascending" }, {
              attach_mappings = function(prompt_bufnr)
                local selected_index = colorscheme_index

                ---@diagnostic disable-next-line: undefined-field
                action_set.shift_selection:enhance({
                  post = function()
                    refresh_colorscheme(
                      actions_state.get_selected_entry().index
                    )
                  end,
                })

                actions.select_default:replace(function()
                  selected_index = actions_state.get_selected_entry().index
                  actions.close(prompt_bufnr)
                end)

                ---@diagnostic disable-next-line: undefined-field
                actions.close:enhance({
                  post = function()
                    refresh_colorscheme(selected_index)
                  end,
                })

                return true
              end,
              finder = require("telescope.finders").new_table({
                results = colorschemes,
                entry_maker = function(entry)
                  local colorscheme_name = get_colorscheme_name(entry)

                  return {
                    display = colorscheme_name,
                    ordinal = colorscheme_name,
                    value = entry,
                  }
                end,
              }),
              layout_config = {
                anchor = "E",
                height = #colorschemes + 5,
                width = max_colorscheme_name_length + 6,
              },
              prompt_title = "Colorschemes",
              sorter = require("telescope.config").values.generic_sorter(),
            })
            :find()
        end,
        desc = "Colorschemes",
      },
    },
  },
}
