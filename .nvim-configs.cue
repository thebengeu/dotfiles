package dotfiles

import (
	"regexp"
	"strings"
)

_nvimConfigs: {
	"ecosse3/nvim":            "ecovim"
	"nvim-lua/kickstart.nvim": "kickstart"
	"LazyVim/starter":         "lazyvim"

	for gitRepo in [
		"AstroNvim/AstroNvim",
		"NvChad/NvChad",
	] {
		"\(gitRepo)": "\(strings.ToLower(regexp.Find("[^/]+$", gitRepo)))"
	}
}
