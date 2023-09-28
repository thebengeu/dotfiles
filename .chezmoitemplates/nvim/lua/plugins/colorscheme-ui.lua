local colorscheme_specs = require("plugins.colorscheme")
local util = require("util")

local colorschemes = {}

for _, spec in ipairs(colorscheme_specs) do
  local name = util.normname(spec.name)

  if spec.colorscheme_styles then
    for _, colorscheme_style in ipairs(spec.colorscheme_styles) do
      table.insert(colorschemes, { name, colorscheme_style })
    end
  elseif spec.colors_names then
    for _, colors_name in ipairs(spec.colors_names) do
      table.insert(colorschemes, { colors_name })
    end
  else
    table.insert(colorschemes, { name })
  end
end

local max_colorscheme_name_length = 0

for _, colorscheme in ipairs(colorschemes) do
  max_colorscheme_name_length =
    math.max(#table.concat(colorscheme, "-"), max_colorscheme_name_length)
end

local colorscheme_index
local colorscheme

local set_colorscheme_style = function(index)
  colorscheme_index = index
  colorscheme = colorschemes[index]
  if colorscheme[2] then
    vim.g[colorscheme[1] .. "_style"] = colorscheme[2]
  end
end

local refresh_colorscheme = function(index)
  set_colorscheme_style(index)
  vim.cmd.colorscheme(colorscheme[1])
  require("lualine").refresh()
end

math.randomseed(os.time())
set_colorscheme_style(math.random(#colorschemes))

vim.keymap.set("n", "<leader>uR", function()
  refresh_colorscheme(math.random(#colorschemes))
end, { desc = "Randomise Colorscheme" })
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
      colorscheme = colorscheme[1],
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            return table.concat(colorscheme, "-"):gsub(" ", "_")
          end,
        },
      },
    },
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
                    local colorscheme_and_style =
                      table.concat(entry, "-"):gsub(" ", "_")

                    return {
                      display = colorscheme_and_style,
                      ordinal = colorscheme_and_style,
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
