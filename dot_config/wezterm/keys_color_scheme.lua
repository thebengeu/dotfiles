local common = require("common")
local wezterm = require("wezterm")

local color_schemes = {
  "Catppuccin Frappé (Gogh)",
  "Catppuccin Macchiato (Gogh)",
  "Catppuccin Mocha (Gogh)",
  "Dracula (Gogh)",
  "Everblush (Gogh)",
  -- "Everforest Dark Hard (Gogh)",
  "Gruvbox Dark (Gogh)",
  "Gruvbox Material (Gogh)",
  "Jellybeans (Gogh)",
  "Kanagawa (Gogh)",
  -- "Kanagawa Dragon (Gogh)",
  "Monokai Pro (Gogh)",
  "Monokai Pro Ristretto (Gogh)",
  "Moonfly (Gogh)",
  "Night Owl (Gogh)",
  "Nightfly (Gogh)",
  "Nord (Gogh)",
  "One Dark (Gogh)",
  "Oxocarbon Dark (Gogh)",
  "Rosé Pine (Gogh)",
  "Rosé Pine Moon (Gogh)",
  "Solarized Dark (Gogh)",
  "Sonokai (Gogh)",
  "Synthwave (Gogh)",
  "Tokyo Night (Gogh)",
  "Tokyo Night Storm (Gogh)",
  "Zenburn (Gogh)",
}

local set_color_scheme = function(window, color_scheme_index)
  color_scheme_index = color_scheme_index or math.random(#color_schemes)
  wezterm.GLOBAL.color_scheme_index = color_scheme_index

  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = color_schemes[color_scheme_index]
  window:set_config_overrides(overrides)
end

wezterm.on("window-config-reloaded", function(window)
  if not window:get_config_overrides() then
    set_color_scheme(window)
  end
end)

local M = {}

function M.apply_to_config(config)
  common.list_extend(config.keys, {
    {
      key = "LeftArrow",
      mods = "SHIFT|ALT",
      action = wezterm.action_callback(function(window)
        local color_scheme_index = wezterm.GLOBAL.color_scheme_index
        set_color_scheme(
          window,
          color_scheme_index == 1 and #color_schemes or color_scheme_index - 1
        )
      end),
    },
    {
      key = "RightArrow",
      mods = "SHIFT|ALT",
      action = wezterm.action_callback(function(window)
        local color_scheme_index = wezterm.GLOBAL.color_scheme_index
        set_color_scheme(
          window,
          color_scheme_index == #color_schemes and 1 or color_scheme_index + 1
        )
      end),
    },
  })
end

return M
