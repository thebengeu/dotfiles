local LazyVim = require("lazyvim.util")
local colorscheme_specs = require("plugins.colorscheme")
local util = require("util")

local colorschemes = {}

for _, spec in ipairs(colorscheme_specs) do
  local name = util.normname(spec.name or spec[1])
  local extra_spec = util.extra_specs[spec[1] or spec.url] or {}

  if extra_spec.colors_names then
    for _, colors_name in ipairs(extra_spec.colors_names) do
      table.insert(colorschemes, { colors_name })
      util.highlights[colors_name] = extra_spec.highlights
    end
  else
    util.highlights[name] = extra_spec.highlights

    if extra_spec.colorscheme_styles then
      for _, colorscheme_style in ipairs(extra_spec.colorscheme_styles) do
        table.insert(colorschemes, { name, colorscheme_style })
      end
    else
      table.insert(colorschemes, { name })
    end
  end
end

local get_colorscheme_name = function(colorscheme)
  return table.concat(colorscheme, "-"):gsub(" ", "_")
end

local max_colorscheme_name_length = 0

for _, colorscheme in ipairs(colorschemes) do
  max_colorscheme_name_length =
    math.max(#get_colorscheme_name(colorscheme), max_colorscheme_name_length)
end

local colorscheme_index

math.randomseed(os.time())

local refresh_colorscheme = function(index)
  colorscheme_index = (index and index >= 1 and index <= #colorschemes)
      and index
    or math.random(#colorschemes)
  local colorscheme = colorschemes[colorscheme_index]
  if colorscheme[2] then
    vim.g[colorscheme[1] .. "_style"] = colorscheme[2]
  end
  vim.cmd.colorscheme(colorscheme[1])
  require("lualine").refresh()
end

local colorscheme_index_path = vim.fn.stdpath("data") .. "/colorscheme_index"

vim.keymap.set("n", "<leader>uR", function()
  os.remove(colorscheme_index_path)
  refresh_colorscheme()
end, { desc = "Randomise Colorscheme" })
vim.keymap.set("n", "<leader>uS", function()
  local file = io.open(colorscheme_index_path, "w")

  if file then
    file:write(colorscheme_index, "\n")
    file:close()
  end
end, { desc = "Save Colorscheme" })
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
        local index
        local file = io.open(colorscheme_index_path)

        if file then
          index = file:read("n")
          file:close()
        end

        refresh_colorscheme(index)
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({ length = 4 }) }
      opts.sections.lualine_z = {
        function()
          return get_colorscheme_name(colorschemes[colorscheme_index])
        end,
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = function(_, keys)
      vim.list_extend(keys, {
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
      })
    end,
  },
}
