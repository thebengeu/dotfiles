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
config.ssh_domains = {}

for _, ssh_domain in ipairs({
	{ "dev-local", "192.168.50.3" },
	{ "dev-remote", "beng.asuscomm.com" },
	{ "ec2", "13.213.181.86", "ubuntu" },
	{ "prod", "192.168.50.4" },
}) do
	table.insert(config.ssh_domains, {
		default_prog = { "tmux", "new-session", "-A", "-s", "0" },
		name = "SSH:" .. ssh_domain[1],
		multiplexing = "None",
		remote_address = ssh_domain[2],
		username = ssh_domain[3] or "beng",
	})
end

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

local wsl_domains = wezterm.default_wsl_domains()

for _, wsl_domain in ipairs(wsl_domains) do
	wsl_domain.default_cwd = "~"
	wsl_domain.default_prog = { "tmux", "new-session", "-A", "-s", "0" }
end

config.wsl_domains = wsl_domains

platform_specific.apply_to_config(config)

return config
