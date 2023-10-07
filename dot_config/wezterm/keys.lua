local common = require("common")
local keys_pane = require("keys_pane")
local keys_split_nav = require("keys_split_nav")
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
  config.keys = {
    { key = "phys:Space", mods = "SHIFT|ALT", action = act.QuickSelect },
    {
      key = "d",
      mods = "SHIFT|CTRL",
      action = act.DetachDomain("CurrentPaneDomain"),
    },
    { key = "t", mods = "SHIFT|ALT", action = act.SpawnTab("DefaultDomain") },
    {
      key = "x",
      mods = "SHIFT|ALT",
      action = act.CloseCurrentPane({ confirm = false }),
    },
    {
      key = "w",
      mods = "SHIFT|CTRL",
      action = act.CloseCurrentTab({ confirm = false }),
    },
    {
      key = "v",
      mods = "CTRL",
      action = act.PasteFrom("Clipboard"),
    },
    { key = "UpArrow", mods = "SHIFT|ALT", action = act.ScrollToPrompt(-1) },
    {
      key = "DownArrow",
      mods = "SHIFT|ALT",
      action = act.ScrollToPrompt(1),
    },
    {
      key = "|",
      mods = "SHIFT|ALT",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "_",
      mods = "SHIFT|ALT",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "h",
      mods = "SHIFT|ALT",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "l",
      mods = "SHIFT|ALT",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "k",
      mods = "SHIFT|ALT",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "j",
      mods = "SHIFT|ALT",
      action = act.ActivatePaneDirection("Down"),
    },
  }

  local add_nvim_key = function(mods, hostname, home_dir)
    table.insert(config.keys, {
      key = "n",
      mods = mods,
      action = wezterm.action_callback(function()
        local latest_focused_nvim_time = 0
        local latest_focused_nvim_pane
        local latest_focused_nvim_port

        common.find_pane(function(pane)
          local user_vars = pane:get_user_vars()

          if user_vars.WEZTERM_HOSTNAME == hostname then
            local focused_nvim_time = tonumber(user_vars.FOCUSED_NVIM_TIME)

            if
              focused_nvim_time
              and focused_nvim_time > latest_focused_nvim_time
            then
              latest_focused_nvim_time = focused_nvim_time
              latest_focused_nvim_pane = pane
              latest_focused_nvim_port = user_vars.NVIM_PORT
            end
          end
        end)

        common.activate_pane(latest_focused_nvim_pane)

        local file =
          io.open(home_dir .. "/.local/bin/nvr-latest-focused-nvim.sh", "w")
        if file then
          file:write(
            (
              latest_focused_nvim_port
                and "nvr -s --nostart --servername 127.0.0.1:" .. latest_focused_nvim_port .. ' "$@" || '
              or ""
            ) .. 'nvim "$@"\n'
          )
          file:close()
        end
      end),
    })
  end

  add_nvim_key(
    "SHIFT|ALT",
    wezterm.hostname() .. "-wsl",
    [[\\wsl.localhost\Ubuntu\home\]] .. os.getenv("USERNAME")
  )
  add_nvim_key("SHIFT|ALT|CTRL", wezterm.hostname(), wezterm.home_dir)

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

  table.insert(config.keys, {
    key = ")",
    mods = "SHIFT|ALT",
    action = wezterm.action_callback(function()
      spawn_or_focus_window(1)
    end),
  })
  table.insert(config.keys, {
    key = ")",
    mods = "SHIFT|ALT|CTRL",
    action = wezterm.action_callback(function()
      spawn_or_focus_window(2)
    end),
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
    table.insert(config.keys, {
      key = key,
      mods = "SHIFT|ALT|CTRL",
      action = wezterm.action_callback(function()
        spawn_or_activate_tab(i)(spawn_or_focus_window(2))
      end),
    })
  end

  keys_pane.apply_to_config(config)
  keys_split_nav.apply_to_config(config)
end

return M
