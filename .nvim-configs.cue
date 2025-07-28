package dotfiles

import (
	"regexp"
	"strings"
)

_nvimConfigs: {
	"AstroNvim/template": "astronvim"
	"ecosse3/nvim":       "ecovim"
	"LazyVim/starter":    "lazyvim"
	"jellydn/tiny-nvim":  "tiny-nvim"
	"NvChad/starter":     "nvchad"

	for gitRepo in [
		"nvim-lua/kickstart.nvim",
		"thebengeu/minimal-lazy.nvim",
	] {
		"\(gitRepo)": "\(strings.ToLower(regexp.Find("[^/]+$", strings.Replace(gitRepo, ".nvim", "", -1))))"
	}
}
