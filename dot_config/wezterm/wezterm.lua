local wezterm = require("wezterm")
local act = wezterm.action

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
      if user_vars.IS_NVIM == "true" or user_vars.WEZTERM_IN_TMUX == "1" then
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

local config = {}

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
if package.config:sub(1, 1) == "\\" then
  config.default_prog = { "fish" }
end
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

local activate_or_spawn_pane = function(domain_name_or_getter)
  return wezterm.action_callback(function(window)
    local latest_prompt_time = 0
    local latest_prompt_pane

    local domain_name = type(domain_name_or_getter) == "function"
        and domain_name_or_getter()
      or domain_name_or_getter

    find_pane(function(pane)
      if
        pane:get_domain_name() == domain_name
        and pane:get_user_vars().WEZTERM_PROG == ""
      then
        local user_vars = pane:get_user_vars()
        local prompt_time = tonumber(user_vars.PROMPT_TIME)

        if prompt_time and prompt_time > latest_prompt_time then
          latest_prompt_time = prompt_time
          latest_prompt_pane = pane
        end
      end
    end)

    activate_pane(latest_prompt_pane)

    if not latest_prompt_pane then
      window:mux_window():spawn_tab({ domain = { DomainName = domain_name } })
    end
  end)
end

config.wsl_domains = map(wezterm.default_wsl_domains(), function(wsl_domain)
  wsl_domain.default_cwd = "~"
  wsl_domain.default_prog = {
    "fish",
    "-C",
    "tmux has-session -t 0 2>/dev/null || tmux new-session -d -s 0",
  }
  return wsl_domain
end)

local first_wsl_domain_name = config.wsl_domains[1].name

config.keys = {
  { key = "phys:Space", mods = "SHIFT|ALT|CTRL", action = act.QuickSelect },
  { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("DefaultDomain") },
  { key = "t", mods = "ALT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  {
    key = "w",
    mods = "SHIFT|CTRL",
    action = act.CloseCurrentTab({ confirm = false }),
  },
  { key = "UpArrow", mods = "SHIFT|ALT|CTRL", action = act.ScrollToPrompt(-1) },
  {
    key = "DownArrow",
    mods = "SHIFT|ALT|CTRL",
    action = act.ScrollToPrompt(1),
  },
  {
    key = "|",
    mods = "SHIFT|ALT|CTRL",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "_",
    mods = "SHIFT|ALT|CTRL",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "\\",
    mods = "ALT|CTRL",
    action = act.SplitHorizontal({ domain = "DefaultDomain" }),
  },
  {
    key = "-",
    mods = "ALT|CTRL",
    action = act.SplitVertical({ domain = "DefaultDomain" }),
  },
  {
    key = "h",
    mods = "SHIFT|ALT|CTRL",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "SHIFT|ALT|CTRL",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "k",
    mods = "SHIFT|ALT|CTRL",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "j",
    mods = "SHIFT|ALT|CTRL",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "n",
    mods = "SHIFT|ALT|CTRL",
    action = wezterm.action_callback(function()
      local latest_focused_nvim_time = 0
      local latest_focused_nvim_pane
      local latest_focused_nvim_port

      find_pane(function(pane)
        local user_vars = pane:get_user_vars()
        local focused_nvim_time = tonumber(user_vars.FOCUSED_NVIM_TIME)

        if
          focused_nvim_time and focused_nvim_time > latest_focused_nvim_time
        then
          latest_focused_nvim_time = focused_nvim_time
          latest_focused_nvim_pane = pane
          latest_focused_nvim_port = user_vars.NVIM_PORT
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
    mods = "SHIFT|ALT|CTRL",
    action = activate_or_spawn_pane(function()
      return wezterm.run_child_process({
        "ncat",
        "-z",
        "--wait",
        "50ms",
        "192.168.50.2",
        "22",
      }) and "SSH:dev-local" or "SSH:dev-remote"
    end),
  },
  {
    key = "e",
    mods = "SHIFT|ALT|CTRL",
    action = activate_or_spawn_pane("SSH:ec2"),
  },
  {
    key = "l",
    mods = "SHIFT|ALT|CTRL",
    action = activate_or_spawn_pane("local"),
  },
  {
    key = "p",
    mods = "SHIFT|ALT|CTRL",
    action = activate_or_spawn_pane(function()
      return wezterm.run_child_process({
        "ncat",
        "-z",
        "--wait",
        "50ms",
        "192.168.50.4",
        "22",
      }) and "SSH:prod-local" or "SSH:prod-remote"
    end),
  },
  {
    key = "v",
    mods = "SHIFT|ALT|CTRL",
    action = activate_or_spawn_pane(function()
      return wezterm.run_child_process({
        "ncat",
        "-z",
        "--wait",
        "50ms",
        "192.168.50.3",
        "22",
      }) and "SSH:dev-wsl-local" or "SSH:dev-wsl-remote"
    end),
  },
  {
    key = "w",
    mods = "SHIFT|ALT|CTRL",
    action = activate_or_spawn_pane(first_wsl_domain_name),
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
    action = wezterm.action_callback(function(window)
      local mux_window = window:mux_window()
      local tabs = mux_window:tabs()
      if i - #tabs > 0 then
        for _ = 1, i - #tabs do
          mux_window:spawn_tab({})
        end
      else
        tabs[i]:activate()
      end
    end),
  })
  table.insert(config.keys, {
    key = key,
    mods = "SHIFT|ALT|CTRL",
    action = wezterm.action_callback(function()
      local windows = wezterm.gui.gui_windows()
      if i - #windows > 0 then
        for _ = 1, i - #windows do
          wezterm.mux.spawn_window({})
        end
      else
        table.sort(windows, function(win1, win2)
          return win1:window_id() < win2:window_id()
        end)
        windows[i]:focus()
      end
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
    "fish -C 'tmux has-session -t 0 2>/dev/null || tmux new-session -d -s 0'",
  },
}, function(args, label)
  return {
    domain = { DomainName = "local" },
    label = label,
    args = args,
  }
end)
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
config.warn_about_missing_glyphs = false
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

return config
