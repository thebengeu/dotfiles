local wezterm = require("wezterm")
local act = wezterm.action

local map = function(input_table, callback)
	local output_table = {}

	for key, value in pairs(input_table) do
		table.insert(output_table, callback(value, key))
	end

	return output_table
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
	{ key = "phys:Space", mods = "SHIFT|ALT|CTRL", action = act.QuickSelect },
	{ key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
}
config.launch_menu = map({
	["Bash"] = { "bash" },
	["Developer PowerShell for VS 2022"] = {
		"powershell",
		"-noe",
		"-c",
		[[&{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell f5ce53b2}]],
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
		"tmux",
		"new-session",
		"-A",
		"-s",
		"0",
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
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
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
config.ssh_domains = map({
	"dev-local",
	"dev-remote",
	"ec2",
	"prod",
}, function(ssh_domain)
	local ssh_domain_config = {
		name = "SSH:" .. ssh_domain,
		multiplexing = "None",
		remote_address = ssh_domain,
	}

	if not ssh_domain:find("^dev%-") then
		ssh_domain_config["default_prog"] = { "tmux", "new-session", "-A", "-s", "0" }
	end

	return ssh_domain_config
end)
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
config.wsl_domains = map(wezterm.default_wsl_domains(), function(wsl_domain)
	wsl_domain.default_cwd = "~"
	wsl_domain.default_prog = { "tmux", "new-session", "-A", "-s", "0" }
	return wsl_domain
end)

return config
