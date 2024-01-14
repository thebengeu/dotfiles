local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
  for i, key in ipairs({
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  }) do
    table.insert(config.keys, {
      key = key,
      mods = "ALT|CTRL|SHIFT",
      action = act.ActivateTab(i - 1),
    })
  end
  for i, key in ipairs({
    "!",
    "@",
    "#",
    "$",
    "%",
    "^",
    "&",
    "*",
    "(",
  }) do
    table.insert(config.keys, {
      key = key,
      mods = "ALT|CTRL",
      action = act.ActivateTab(i - 1),
    })
    table.insert(config.keys, {
      key = key,
      mods = "ALT|CTRL|SHIFT",
      action = act.ActivateTab(i - 1),
    })
  end
end

return M
