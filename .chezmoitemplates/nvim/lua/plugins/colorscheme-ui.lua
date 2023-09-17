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

local colorscheme_index
local colorscheme

local set_colorscheme_style = function(index)
  colorscheme_index = index
  colorscheme = colorschemes[index]
  if colorscheme[2] then
    vim.g[colorscheme[1] .. "_style"] = colorscheme[2]
  end
end

math.randomseed(os.time())
set_colorscheme_style(math.random(#colorschemes))

vim.keymap.set("n", "<leader>uR", function()
  set_colorscheme_style(math.random(#colorschemes))
  vim.cmd.colorscheme(colorscheme[1])
end, { desc = "Randomise Colorscheme" })
vim.keymap.set("n", "[S", function()
  set_colorscheme_style(colorscheme_index == 1 and #colorschemes or colorscheme_index - 1)
  vim.cmd.colorscheme(colorscheme[1])
end, { desc = "Colorscheme backward" })
vim.keymap.set("n", "]S", function()
  set_colorscheme_style(colorscheme_index == #colorschemes and 1 or colorscheme_index + 1)
  vim.cmd.colorscheme(colorscheme[1])
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
            require("telescope.pickers")
              .new({}, {
                attach_mappings = function(prompt_bufnr)
                  local actions = require("telescope.actions")
                  actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    set_colorscheme_style(selection.index)
                    vim.cmd.colorscheme(colorscheme[1])
                  end)
                  return true
                end,
                finder = require("telescope.finders").new_table({
                  results = colorschemes,
                  entry_maker = function(entry)
                    local colorscheme_and_style = table.concat(entry, "-"):gsub(" ", "_")

                    return {
                      display = colorscheme_and_style,
                      ordinal = colorscheme_and_style,
                      value = entry,
                    }
                  end,
                }),
                sorter = require("telescope.config").values.generic_sorter(),
              })
              :find()
          end,
          desc = "Colorscheme",
        },
      })
    end,
  },
}
