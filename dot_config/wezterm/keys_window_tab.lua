local wezterm = require("wezterm")

local spawn_or_activate_tab = function(i)
  return function(window)
    local mux_window = window:mux_window()
    local tabs = mux_window:tabs()
    if i - #tabs > 0 then
      for _ = 1, i - #tabs do
        mux_window:spawn_tab({})
      end
    else
      tabs[i]:activate()
    end
  end
end

local M = {}

function M.apply_to_config(config)
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
      mods = "SHIFT|CTRL",
      action = wezterm.action_callback(spawn_or_activate_tab(i)),
    })
  end
end

return M
