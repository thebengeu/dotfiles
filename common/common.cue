package common

import (
	"regexp"
	"strings"
)

nvimConfigs: {
	for gitRepo in [
		"AstroNvim/AstroNvim",
		"NvChad/NvChad",
	] {
		"\(gitRepo)": "\(strings.ToLower(regexp.Find("[^/]+$", gitRepo)))"
	}
}
