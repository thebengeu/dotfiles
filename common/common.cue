package common

import (
	"regexp"
	"strings"
)

nvimConfigs: {
	"ecosse3/nvim":    "ecovim"
	"LazyVim/starter": "lazyvim"

	for gitRepo in [
		"AstroNvim/AstroNvim",
		"NvChad/NvChad",
	] {
		"\(gitRepo)": "\(strings.ToLower(regexp.Find("[^/]+$", gitRepo)))"
	}
}
