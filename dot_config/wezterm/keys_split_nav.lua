local common = require("common")
local wezterm = require("wezterm")

local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      local user_vars = pane:get_user_vars()
      if
        tonumber(user_vars.FOCUSED_NVIM_TIME) ~= nil
        or user_vars.WEZTERM_IN_TMUX == "1"
      then
        win:perform_action({
          SendKey = {
            key = key,
            mods = resize_or_move == "resize" and "META" or "CTRL",
          },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action(
            { AdjustPaneSize = { direction_keys[key], 3 } },
            pane
          )
        else
          win:perform_action(
            { ActivatePaneDirection = direction_keys[key] },
            pane
          )
        end
      end
    end),
  }
end

local M = {}

function M.apply_to_config(config)
  common.list_extend(config.keys, {
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),
  })
end

return M
