local keys_nvim = require("keys_nvim")
local keys_pane = require("keys_pane")
local keys_split_nav = require("keys_split_nav")
local keys_window_tab = require("keys_window_tab")
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
  config.keys = {
    {
      key = "phys:Space",
      mods = "SHIFT|ALT",
      action = act.QuickSelect,
    },
    {
      key = "d",
      mods = "SHIFT|CTRL",
      action = act.DetachDomain("CurrentPaneDomain"),
    },
    {
      key = "t",
      mods = "SHIFT|ALT",
      action = act.SpawnTab("DefaultDomain"),
    },
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
      key = "w",
      mods = "SUPER",
      action = act.CloseCurrentTab({ confirm = false }),
    },
    {
      key = "v",
      mods = "CTRL",
      action = act.DisableDefaultAssignment,
    },
    {
      key = "UpArrow",
      mods = "SHIFT|ALT",
      action = act.ScrollToPrompt(-1),
    },
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
    {
      key = "<",
      mods = "SHIFT|CTRL",
      action = act.MoveTabRelative(-1),
    },
    {
      key = ">",
      mods = "SHIFT|CTRL",
      action = act.MoveTabRelative(1),
    },
    {
      key = "h",
      mods = "SHIFT|CTRL",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "k",
      mods = "SHIFT|CTRL",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "l",
      mods = "SHIFT|CTRL",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "d",
      mods = "SHIFT|CTRL",
      action = act.ShowDebugOverlay,
    },
    {
      key = "b",
      mods = "SHIFT|CTRL",
      action = act.ClearScrollback("ScrollbackOnly"),
    },
  }

  keys_nvim.apply_to_config(config)
  keys_pane.apply_to_config(config)
  keys_split_nav.apply_to_config(config)
  keys_window_tab.apply_to_config(config)
end

return M
