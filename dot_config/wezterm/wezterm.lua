local wezterm = require("wezterm")
local act = wezterm.action

if wezterm.GLOBAL.is_remote == nil then
  local _, stdout, _ = wezterm.run_child_process({ "ipconfig" })
  wezterm.GLOBAL.is_remote = not stdout:find("192%.168%.50%.1")
end

local is_remote = wezterm.GLOBAL.is_remote

local map = function(input_table, callback)
  local output_table = {}

  for key, value in pairs(input_table) do
    table.insert(output_table, callback(value, key))
  end

  return output_table
end

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

local config = wezterm.config_builder()
config:set_strict_mode(true)

config.adjust_window_size_when_changing_font_size = false
config.color_scheme = "Catppuccin Mocha"
config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#cba6f7",
      fg_color = "#11111b",
    },
    inactive_tab = {
      bg_color = "#181825",
      fg_color = "#cdd6f4",
    },
    inactive_tab_hover = {
      bg_color = "#181825",
      fg_color = "#cdd6f4",
    },
  },
}
config.default_cursor_style = "SteadyBar"
config.default_domain = "SSHMUX:wsl"
config.default_prog = { "fish", "-C", "set --export TERM xterm-256color" }
-- config.font = wezterm.font("PragmataProLiga NF")
-- config.font_rules = {
-- 	{
-- 		font = wezterm.font({
-- 			family = "PragmataProLiga NF",
-- 			harfbuzz_features = { "ss09" },
-- 			style = "Italic",
-- 		}),
-- 		italic = true,
-- 	},
-- }
config.font = wezterm.font("MonoLisa Variable")
config.font_rules = {
  {
    font = wezterm.font({
      family = "MonoLisa Variable",
      harfbuzz_features = { "ss02" },
      style = "Italic",
    }),
    italic = true,
  },
}
config.font_size = 13
config.front_end = "OpenGL"
config.inactive_pane_hsb = {
  saturation = 0.75,
  brightness = 0.75,
}

local find_pane = function(callback)
  for _, window in ipairs(wezterm.gui.gui_windows()) do
    for _, tab in ipairs(window:mux_window():tabs()) do
      for _, pane in ipairs(tab:panes()) do
        local found_pane = callback(pane)

        if found_pane then
          return found_pane
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
  return wezterm.action_callback(function(window, event_pane)
    local latest_prompt_time = 0
    local latest_prompt_pane

    find_pane(function(pane)
      local user_vars = pane:get_user_vars()

      if
        user_vars.WEZTERM_HOSTNAME == hostname
        and user_vars.WEZTERM_PROG == ""
      then
        local prompt_time = tonumber(user_vars.PROMPT_TIME)

        if prompt_time and prompt_time > latest_prompt_time then
          latest_prompt_time = prompt_time
          latest_prompt_pane = pane
        end
      end
    end)

    activate_pane(latest_prompt_pane)

    if not latest_prompt_pane then
      domain_name = domain_name or ("SSHMUX:" .. hostname)
      window:perform_action(act.AttachDomain(domain_name), event_pane)
      wezterm.sleep_ms(200)
      window:perform_action(act.ActivateTab(-1), event_pane)
    end
  end)
end

config.ssh_domains = map(wezterm.default_ssh_domains(), function(domain)
  if domain.name:find("%:wsl$") then
    domain.assume_shell = "Posix"
    domain.default_prog = {
      "fish",
      "-C",
      "set --export SSH_ORIGIN_HOSTNAME "
        .. wezterm.hostname()
        .. "; fish_add_path --global /mnt/c/Users/"
        .. os.getenv("USERNAME")
        .. "/scoop/shims",
    }
  elseif is_remote and not domain.name:find("%:ec2$") then
    domain.remote_address = "beng.asuscomm.com"
    domain.ssh_option = {
      port = domain.name:find("%:dev-wsl$") and "24"
        or (domain.name:find("%:prod$") and "26" or "22"),
    }
  end

  return domain
end)

table.insert(config.ssh_domains, {
  name = "SSHMUX:localhost",
  remote_address = "localhost",
})

config.wsl_domains = map(wezterm.default_wsl_domains(), function(wsl_domain)
  wsl_domain.default_cwd = "~"
  wsl_domain.default_prog = {
    "/usr/bin/fish",
    "-C",
    "tmux has-session -t 0 2>/dev/null || tmux new-session -d -s 0",
  }
  return wsl_domain
end)

config.keys = {
  { key = "phys:Space", mods = "SHIFT|ALT", action = act.QuickSelect },
  { key = "t", mods = "SHIFT|ALT", action = act.SpawnTab("DefaultDomain") },
  {
    key = ")",
    mods = "SHIFT|ALT|CTRL",
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
    key = "\\",
    mods = "ALT|CTRL",
    action = act.SplitHorizontal({ domain = { DomainName = "SSH:wsl" } }),
  },
  {
    key = "-",
    mods = "ALT|CTRL",
    action = act.SplitVertical({ domain = { DomainName = "SSH:wsl" } }),
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
    key = "n",
    mods = "SHIFT|ALT",
    action = wezterm.action_callback(function()
      local latest_focused_nvim_time = 0
      local latest_focused_nvim_pane
      local latest_focused_nvim_port

      find_pane(function(pane)
        local user_vars = pane:get_user_vars()

        if user_vars.WEZTERM_HOSTNAME == wezterm.hostname() then
          local focused_nvim_time = tonumber(user_vars.FOCUSED_NVIM_TIME)

          if
            focused_nvim_time and focused_nvim_time > latest_focused_nvim_time
          then
            latest_focused_nvim_time = focused_nvim_time
            latest_focused_nvim_pane = pane
            latest_focused_nvim_port = user_vars.NVIM_PORT
          end
        end
      end)

      activate_pane(latest_focused_nvim_pane)

      local file = io.open(
        wezterm.home_dir .. "/.local/bin/nvr-latest-focused-nvim.sh",
        "w"
      )
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
  },
  {
    key = "d",
    mods = "SHIFT|ALT",
    action = activate_or_spawn_pane("dev"),
  },
  {
    key = "e",
    mods = "SHIFT|ALT",
    action = activate_or_spawn_pane("ec2"),
  },
  {
    key = "a",
    mods = "SHIFT|ALT",
    action = activate_or_spawn_pane(wezterm.hostname(), "SSHMUX:localhost"),
  },
  {
    key = "p",
    mods = "SHIFT|ALT",
    action = activate_or_spawn_pane("prod"),
  },
  {
    key = "v",
    mods = "SHIFT|ALT",
    action = activate_or_spawn_pane("dev-wsl"),
  },
  {
    key = "w",
    mods = "SHIFT|ALT",
    action = activate_or_spawn_pane(wezterm.hostname() .. "-wsl", "SSHMUX:wsl"),
  },
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
}

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
  key = "0",
  mods = "ALT|CTRL",
  action = wezterm.action_callback(function()
    spawn_or_focus_window(1)
  end),
})
table.insert(config.keys, {
  key = ")",
  mods = "SHIFT|ALT",
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
    key = tostring(i),
    mods = "ALT|CTRL",
    action = wezterm.action_callback(function()
      spawn_or_activate_tab(i)(spawn_or_focus_window(2))
    end),
  })
end

config.launch_menu = map({
  ["Bash"] = { "bash" },
  ["Developer PowerShell for VS 2022"] = {
    "powershell",
    "-c",
    [[Invoke-Expression ("pwsh " + (New-Object -ComObject WScript.Shell).CreateShortcut("$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk").Arguments.Replace('"""', "'"))]],
  },
  ["fish"] = { "fish" },
  ["Nushell"] = { "nu" },
  ["PowerShell"] = { "pwsh", "-NoLogo" },
  ["Windows PowerShell"] = { "powershell", "-NoLogo" },
  ["zsh"] = { "zsh" },
  ["Restart WSL"] = {
    "wezterm",
    "cli",
    "spawn",
    "--domain-name",
    "local",
    "--",
    "powershell",
    "-NoProfile",
    "-Command",
    "wsl",
    "--shutdown",
    ";",
    "wsl",
    "--cd",
    "~",
    "--exec",
    "/usr/bin/fish -C 'tmux has-session -t 0 2>/dev/null || tmux new-session -d -s 0'",
  },
}, function(args, label)
  return {
    domain = { DomainName = "local" },
    label = label,
    args = args,
  }
end)
config.prefer_egl = true
config.quick_select_patterns = {
  -- https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file
  [[(?:~|[A-Za-z]:)(?:\\[^<>:"/\|?*]+)+]],
}
config.scrollback_lines = 1000000
config.show_new_tab_button_in_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
config.skip_close_confirmation_for_processes_named = {
  "bash.exe",
  "conhost.exe",
  "fish.exe",
  "nu.exe",
  "tmux",
  "wsl.exe",
  "wslhost.exe",
  "zsh.exe",
}
config.term = "wezterm"
config.underline_position = "-0.2cell"
config.underline_thickness = "0.05cell"
config.warn_about_missing_glyphs = false
config.webgpu_power_preference = "HighPerformance"
config.window_background_opacity = 0.95
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_frame = {
  active_titlebar_bg = "#1e1e2e",
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local nerdfonts = wezterm.nerdfonts
local process_name_icons = {
  [""] = nerdfonts.cod_debug_console,
  bash = nerdfonts.cod_terminal_bash,
  fish = nerdfonts.md_fish,
  pwsh = nerdfonts.cod_terminal_powershell,
  powershell = nerdfonts.cod_terminal_powershell,
  zsh = nerdfonts.cod_terminal,
}

wezterm.on("format-tab-title", function(tab)
  local active_pane = tab.active_pane
  local foreground_process_name = active_pane.foreground_process_name
    :gsub("%.exe$", "")
    :gsub(".-(%w+)$", "%1")
  local user_vars = active_pane.user_vars
  local hostname = user_vars.WEZTERM_HOSTNAME
  local prog = (user_vars.WEZTERM_PROG or ""):gsub(" .*", "")

  local icon = prog == "nvim" and nerdfonts.custom_vim
    or (
      hostname == (wezterm.hostname() .. "-wsl")
        and nerdfonts.cod_terminal_linux
      or (
        user_vars.WEZTERM_IN_TMUX == "1" and nerdfonts.cod_terminal_tmux
        or (
          (hostname and hostname ~= wezterm.hostname() and nerdfonts.md_ssh)
          or process_name_icons[foreground_process_name]
          or ""
        )
      )
    )

  return tab.tab_index + 1
    .. ": "
    .. icon
    .. " "
    .. active_pane.title:gsub("%.exe$", "")
end)

return config
