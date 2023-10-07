local keys_split_nav = require("keys_split_nav")
local wezterm = require("wezterm")
local act = wezterm.action

local find_pane = function(callback)
  for _, window in ipairs(wezterm.gui.gui_windows()) do
    for _, tab in ipairs(window:mux_window():tabs()) do
      for _, pane in ipairs(tab:panes()) do
        local found_pane = callback(pane)

        if found_pane then
          return pane
        end
      end
    end
  end
end

local activate_pane = function(pane)
  if pane then
    pane:window():gui_window():focus()
    pane:activate()
  end
end

local activate_or_spawn_pane = function(hostname, domain_name)
  domain_name = domain_name or ("SSHMUX:" .. hostname)

  return wezterm.action_callback(function(window, event_pane)
    local latest_prompt_time = 0
    local latest_prompt_pane

    find_pane(function(pane)
      local matched
      local user_vars = pane:get_user_vars()

      if user_vars.WEZTERM_HOSTNAME then
        matched = user_vars.WEZTERM_HOSTNAME == hostname
          and user_vars.WEZTERM_PROG == ""
      else
        matched = (pane:get_domain_name() == domain_name)
      end

      if matched then
        local prompt_time = tonumber(user_vars.PROMPT_TIME) or 0

        if prompt_time >= latest_prompt_time then
          latest_prompt_time = prompt_time
          latest_prompt_pane = pane
        end
      end
    end)

    activate_pane(latest_prompt_pane)

    if not latest_prompt_pane then
      if domain_name:find("^SSHMUX%:") then
        local tab_size = window:active_tab():get_size()

        window:perform_action(act.AttachDomain(domain_name), event_pane)

        local domain_pane

        while not domain_pane do
          wezterm.sleep_ms(1)
          domain_pane = find_pane(function(pane)
            return pane:get_domain_name() == domain_name
          end)
        end

        activate_pane(domain_pane)

        local domain_tab_size = domain_pane:tab():get_size()

        if
          domain_tab_size.pixel_height ~= tab_size.pixel_height
          or domain_tab_size.pixel_width ~= tab_size.pixel_width
        then
          local window_dimensions = window:get_dimensions()

          if
            wezterm.hostname() == "yoga"
            and window_dimensions.pixel_width == 3840
            and window_dimensions.pixel_height == 2320
          then
            wezterm.sleep_ms(100)
            window:toggle_fullscreen()
            window:toggle_fullscreen()
          else
            wezterm.sleep_ms(10)
            window:set_inner_size(
              window_dimensions.pixel_width - 1,
              window_dimensions.pixel_height - 59
            )
            window:set_inner_size(
              window_dimensions.pixel_width,
              window_dimensions.pixel_height - 58
            )
          end
        end
      else
        window:mux_window():spawn_tab({
          domain = {
            DomainName = domain_name,
          },
        })
      end
    end
  end)
end

local split_pane = function(domain_name, direction)
  return wezterm.action_callback(function(window, pane)
    local sshmux_hostname = pane:get_domain_name():match("^SSHMUX:(.*)")

    if sshmux_hostname then
      local _, spawned_pane, _ = window:mux_window():spawn_tab({
        domain = { DomainName = "SSH:" .. sshmux_hostname },
      })
      pane = spawned_pane
    end

    pane:split({
      direction = direction or "Right",
      domain = { DomainName = domain_name },
    })
  end)
end

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
      key = "|",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:wsl"),
    },
    {
      key = "_",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:wsl", "Bottom"),
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
      key = "d",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("dev"),
    },
    {
      key = "d",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:dev"),
    },
    {
      key = "e",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("ec2"),
    },
    {
      key = "e",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:ec2"),
    },
    {
      key = "a",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane(wezterm.hostname(), "local"),
    },
    {
      key = "a",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("local"),
    },
    {
      key = "p",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("prod"),
    },
    {
      key = "p",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:prod"),
    },
    {
      key = "v",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("dev-wsl"),
    },
    {
      key = "v",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:dev-wsl"),
    },
    {
      key = "w",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane(
        wezterm.hostname() .. "-wsl",
        "SSHMUX:wsl"
      ),
    },
    {
      key = "w",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane("SSH:wsl"),
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

        find_pane(function(pane)
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

        activate_pane(latest_focused_nvim_pane)

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

  keys_split_nav.apply_to_config(config)
end

return M
