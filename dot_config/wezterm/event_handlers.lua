local common = require("common")
local wezterm = require("wezterm")
local nerdfonts = wezterm.nerdfonts

local process_name_icons = {
  [""] = nerdfonts.cod_debug_console,
  bash = nerdfonts.cod_terminal_bash,
  fish = nerdfonts.md_fish,
  pwsh = nerdfonts.cod_terminal_powershell,
  powershell = nerdfonts.cod_terminal_powershell,
  zsh = nerdfonts.cod_terminal,
}

local M = {}

function M.apply_to_config(config)
  wezterm.on("format-tab-title", function(tab)
    local active_pane = tab.active_pane
    local foreground_process_name = active_pane.foreground_process_name
      :gsub("%.exe$", "")
      :gsub(".-(%w+)$", "%1")
    local user_vars = active_pane.user_vars
    local hostname = user_vars.WEZTERM_HOSTNAME
    local prog = (user_vars.WEZTERM_PROG or ""):gsub(" .*", "")

    local icon = (prog == "nvim" and nerdfonts.custom_vim)
      or (hostname == (wezterm.hostname() .. "-wsl") and nerdfonts.cod_terminal_linux)
      or (user_vars.WEZTERM_IN_TMUX == "1" and nerdfonts.cod_terminal_tmux)
      or (hostname and hostname ~= wezterm.hostname() and nerdfonts.md_ssh)
      or process_name_icons[foreground_process_name]
      or ""

    return tab.tab_index + 1
      .. ": "
      .. icon
      .. " "
      .. active_pane.title:gsub("%.exe$", "")
  end)

  wezterm.on("format-window-title", function(tab)
    return tab.active_pane.title:gsub("%.exe$", "")
  end)

  if wezterm.target_triple:match("%%-pc%-windows%-msvc$") then
    wezterm.on("gui-startup", function()
      wezterm.run_child_process({
        "wsl",
        "--exec",
        "sh",
        "-c",
        common.tmux_detached_session,
      })
      wezterm.mux.get_domain(config.default_domain):attach()
    end)
  end

  wezterm.on("update-status", function(window, pane)
    window:set_right_status("   " .. pane:get_domain_name() .. "   ")
  end)
end

return M
