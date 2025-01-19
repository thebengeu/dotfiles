local common = require("common")
local domains = require("domains")
local event_handlers = require("event_handlers")
local keys = require("keys")
local wezterm = require("wezterm")

local config = wezterm.config_builder()
config:set_strict_mode(true)

local tabline =
  wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    tabs_enabled = false,
  },
  sections = {
    tabline_a = {},
    tabline_b = {},
    tabline_c = {},
    tabline_x = {},
    tabline_y = {},
    tabline_z = { "domain" },
  },
})

local is_windows = wezterm.target_triple:match("%%-pc%-windows%-msvc$")

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

local FONT_NAME = "MonoLisa Variable"
local HARFBUZZ_FEATURES = { "ss02" }
local WINDOWS_FONT_SIZE = 13
local NON_WINDOWS_FONT_SIZE = 17

-- local FONT_NAME = "PragmataPro Mono Liga"
-- local HARFBUZZ_FEATURES = { "ss09" }
-- local WINDOWS_FONT_SIZE = 16
-- local NON_WINDOWS_FONT_SIZE = 20

config.font = wezterm.font(FONT_NAME)
config.font_rules = {
  {
    font = wezterm.font({
      family = FONT_NAME,
      harfbuzz_features = HARFBUZZ_FEATURES,
      style = "Italic",
    }),
    italic = true,
  },
}
config.font_size = is_windows and WINDOWS_FONT_SIZE or NON_WINDOWS_FONT_SIZE

config.inactive_pane_hsb = {
  saturation = 0.75,
  brightness = 0.75,
}

local launch_menu = {
  ["Bash"] = { "bash" },
  ["fish"] = { "fish" },
  ["Nushell"] = { "nu" },
  ["zsh"] = { "zsh" },
}

if is_windows then
  config.default_domain = "SSH:wsl"
  config.default_prog = { "fish" }

  launch_menu["Developer PowerShell for VS 2022"] = {
    "powershell",
    "-c",
    [[Invoke-Expression ("pwsh " + (New-Object -ComObject WScript.Shell).CreateShortcut("$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk").Arguments.Replace('"""', "'"))]],
  }
  launch_menu["PowerShell"] = { "pwsh", "-NoLogo" }
  launch_menu["Windows PowerShell"] = { "powershell", "-NoLogo" }
  launch_menu["Restart WSL"] = {
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
    wezterm.shell_join_args(common.fish_tmux_detached_session),
  }
end

config.launch_menu = common.map(launch_menu, function(args, label)
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
config.underline_position = (is_windows and "-0.2" or "-0.175") .. "cell"
config.underline_thickness = "0.05cell"
config.warn_about_missing_glyphs = false
config.webgpu_power_preference = "HighPerformance"
config.window_background_opacity = 0.95
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_frame = {
  active_titlebar_bg = "#1e1e2e",
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

domains.apply_to_config(config)
event_handlers.apply_to_config(config)
keys.apply_to_config(config)

return config
