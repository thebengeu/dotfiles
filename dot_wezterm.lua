local platform_specific = require("platform_specific")
local wezterm = require("wezterm")
local act = wezterm.action

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
-- config.font_size = 13
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
config.font_size = 12
config.keys = {
	{ key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = false }) },
}
config.launch_menu = {
	{
		args = {
			"wezterm",
			"cli",
			"spawn",
			"--domain-name",
			"local",
			"--",
			"powershell",
			"wsl",
			"--shutdown",
			";",
			"wsl",
		},
		domain = { DomainName = "local" },
		label = "Restart WSL",
	},
}
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.skip_close_confirmation_for_processes_named = {
	"conhost.exe",
	"tmux",
	"wsl.exe",
	"wslhost.exe",
}
config.ssh_domains = {
	{
		name = "SSH:dev-local",
		multiplexing = "None",
		remote_address = "192.168.50.3",
		username = "beng",
	},
	{
		name = "SSH:dev-remote",
		multiplexing = "None",
		remote_address = "beng.asuscomm.com",
		username = "beng",
	},
	{
		name = "SSH:ec2",
		multiplexing = "None",
		remote_address = "13.213.181.86",
		username = "ubuntu",
	},
	{
		name = "SSH:prod",
		multiplexing = "None",
		remote_address = "192.168.50.4",
		username = "beng",
	},
}
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

platform_specific.apply_to_config(config)

return config
