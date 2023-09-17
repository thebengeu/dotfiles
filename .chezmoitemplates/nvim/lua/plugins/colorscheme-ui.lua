local colorschemes = {
  { "bamboo" },
  { "bluloco" },
  { "carbonfox" },
  { "catppuccin-frappe" },
  { "catppuccin-macchiato" },
  { "catppuccin-mocha" },
  { "darker" },
  { "darksolar" },
  { "deepocean" },
  { "dracula" },
  { "dracula-soft" },
  { "dracula_blood" },
  { "duckbones" },
  { "duskfox" },
  { "earlysummer" },
  { "earlysummer_lighter" },
  { "edge", "aura" },
  { "edge", "default" },
  { "edge", "neon" },
  { "emerald" },
  { "everforest" },
  { "forestbones" },
  { "github_dark" },
  { "github_dark_dimmed" },
  { "github_dark_high_contrast" },
  { "gruvbox" },
  { "gruvbox-baby" },
  { "gruvbox-material" },
  { "kanagawa-dragon" },
  { "kanagawa-wave" },
  { "kanagawabones" },
  { "mariana" },
  { "mariana_lighter" },
  { "material", "darker" },
  { "material", "deep ocean" },
  { "material", "oceanic" },
  { "material", "palenight" },
  { "middlenight_blue" },
  { "minicyan" },
  { "minischeme" },
  { "monokai" },
  { "monokai_lighter" },
  { "moonfly" },
  { "moonlight" },
  { "neobones" },
  { "nightfly" },
  { "nightfox" },
  { "nordbones" },
  { "nordfox" },
  { "nordic" },
  { "oceanic" },
  { "one_monokai" },
  { "onedark" },
  { "onedark_dark" },
  { "onedark_vivid" },
  { "onenord" },
  { "palenight" },
  { "poimandres" },
  { "rose-pine" },
  { "rosebones" },
  { "seoulbones" },
  { "sonokai", "andromeda" },
  { "sonokai", "atlantis" },
  { "sonokai", "default" },
  { "sonokai", "espresso" },
  { "sonokai", "maia" },
  { "sonokai", "shusia" },
  { "starry" },
  { "terafox" },
  { "tokyobones" },
  { "tokyonight-moon" },
  { "tokyonight-night" },
  { "tokyonight-storm" },
  { "tundra" },
  { "vscode" },
  { "zenbones" },
  { "zenburned" },
  { "zenwritten" },
}

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
end, { desc = "Colorscheme backward" })

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
