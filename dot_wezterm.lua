local wezterm = require("wezterm")
return {
	color_scheme = "Catppuccin Mocha",
	-- default_domain = "WSL:Ubuntu",
	default_prog = { "tmux", "new-session", "-A", "-s", "0" },
	font = wezterm.font("MonoLisa Variable"),
	font_rules = {
		{
			font = wezterm.font({
				family = "MonoLisa Variable",
				harfbuzz_features = { "ss02" },
				style = "Italic",
			}),
			italic = true,
		},
	},
	font_size = 11,
	hide_tab_bar_if_only_one_tab = true,
	skip_close_confirmation_for_processes_named = { "conhost.exe", "wsl.exe", "wslhost.exe" },
}
