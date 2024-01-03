local common = require("common")
local wezterm = require("wezterm")

local spawn_or_focus_window = function(i)
  local windows = wezterm.gui.gui_windows()
  if i - #windows > 0 then
    for _ = 1, i - #windows do
      local _, _, window = wezterm.mux.spawn_window({})
      return window:gui_window()
    end
  else
    table.sort(windows, function(win1, win2)
      return win1:window_id() < win2:window_id()
    end)
    windows[i]:focus()
    return windows[i]
  end
end

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
  common.list_extend(config.keys, {
    {
      key = ")",
      mods = "SHIFT|ALT",
      action = wezterm.action_callback(function()
        spawn_or_focus_window(1)
      end),
    },
  })

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
    table.insert(config.keys, {
      key = key,
      mods = "SHIFT|ALT",
      action = wezterm.action_callback(function()
        spawn_or_activate_tab(i)(spawn_or_focus_window(1))
      end),
    })
  end
end

return M
