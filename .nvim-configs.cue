package dotfiles

import (
	"regexp"
	"strings"
)

_nvimConfigs: {
	"ecosse3/nvim":    "ecovim"
	"LazyVim/starter": "lazyvim"

	for gitRepo in [
		"AstroNvim/AstroNvim",
		"nvim-lua/kickstart.nvim",
		"thebengeu/minimal-lazy.nvim",
		"NvChad/NvChad",
	] {
		"\(gitRepo)": "\(strings.ToLower(regexp.Find("[^/]+$", strings.Replace(gitRepo, ".nvim", "", -1))))"
	}
}
