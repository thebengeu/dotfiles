local wezterm = require 'wezterm'
return {
  color_scheme = 'Catppuccin Mocha',
  default_prog = { 'tmux', 'new-session', '-A', '-s', '0' },
  font = wezterm.font 'MonoLisa Variable',
  font_size = 11,
  hide_tab_bar_if_only_one_tab = true
}
