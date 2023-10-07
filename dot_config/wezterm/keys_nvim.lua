local common = require("common")
local wezterm = require("wezterm")

local activate_nvim = function(mods, hostname, home_dir)
  return {
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
  }
end

local M = {}

function M.apply_to_config(config)
  common.list_extend(config.keys, {
    activate_nvim(
      "SHIFT|ALT",
      wezterm.hostname() .. "-wsl",
      [[\\wsl.localhost\Ubuntu\home\]] .. os.getenv("USERNAME")
    ),
    activate_nvim("SHIFT|ALT|CTRL", wezterm.hostname(), wezterm.home_dir),
  })
end

return M
