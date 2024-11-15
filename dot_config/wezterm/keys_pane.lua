local common = require("common")
local wezterm = require("wezterm")
local act = wezterm.action

local activate_or_spawn_pane = function(hostname, domain_name)
  domain_name = domain_name or ("SSHMUX:" .. hostname)

  return wezterm.action_callback(function(window, event_pane)
    local latest_prompt_time = 0
    local latest_prompt_pane

    common.find_pane(function(pane)
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

    common.activate_pane(latest_prompt_pane)

    if not latest_prompt_pane then
      if domain_name:match("^SSHMUX%:") then
        local tab_size = window:active_tab():get_size()

        window:perform_action(act.AttachDomain(domain_name), event_pane)

        local domain_pane

        while not domain_pane do
          wezterm.sleep_ms(1)
          domain_pane = common.find_pane(function(pane)
            return pane:get_domain_name() == domain_name
          end)
        end

        common.activate_pane(domain_pane)

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
  common.list_extend(config.keys, {
    {
      key = "|",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane(
        wezterm.target_triple:match("%%-pc%-windows%-msvc$") and "SSH:wsl"
          or "local"
      ),
    },
    {
      key = "_",
      mods = "SHIFT|ALT|CTRL",
      action = split_pane(
        wezterm.target_triple:match("%%-pc%-windows%-msvc$") and "SSH:wsl"
          or "local",
        "Bottom"
      ),
    },
    {
      key = "a",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane(wezterm.hostname(), "local"),
    },
    {
      key = "a",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("local"),
    },
    {
      key = "d",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("dev"),
    },
    {
      key = "d",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:dev"),
    },
    {
      key = "e",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("dev-wsl"),
    },
    {
      key = "e",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:dev-wsl"),
    },
    {
      key = "h",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("hc"),
    },
    {
      key = "h",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:hc"),
    },
    {
      key = "m",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("mbp-2023"),
    },
    {
      key = "m",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:mbp-2023"),
    },
    {
      key = "p",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("prod"),
    },
    {
      key = "p",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:prod"),
    },
    {
      key = "s",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane("staging"),
    },
    {
      key = "s",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:staging"),
    },
    {
      key = "w",
      mods = "SHIFT|ALT",
      action = activate_or_spawn_pane(wezterm.hostname() .. "-wsl", "SSH:wsl"),
    },
    {
      key = "w",
      mods = "ALT|CTRL|SUPER",
      action = split_pane("SSH:wsl"),
    },
  })
end

return M
