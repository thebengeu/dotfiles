import "regexp"

#External: {
	refreshPeriod: "168h"
	type:          "file" | "git-repo"
	url:           string
}

#GitRepo: {
	#External
	_gitRepo: string
	type:     "git-repo"
	url:      "https://github.com/\(_gitRepo)"
}

_gitRepos: [
	"Aloxaf/fzf-tab",
	"b4b4r07/enhancd",
	"jeffreytse/zsh-vi-mode",
	"olets/zsh-abbr",
	"romkatv/powerlevel10k",
	"Freed-Wu/fzf-tab-source",
]

for gitRepo in _gitRepos {
	"\(regexp.Find("[^/]+$", gitRepo))": #GitRepo & {
		_gitRepo: gitRepo
	}
}

".tmux/plugins/tpm": #GitRepo & {
	_gitRepo: "tmux-plugins/tpm"
}

"wezterm.sh": #External & {
	type: "file"
	url:  "https://raw.githubusercontent.com/wez/wezterm/main/assets/shell-integration/wezterm.sh"
}
