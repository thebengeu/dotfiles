import "regexp"

#GitRepo: {
	_gitRepo:      string
	refreshPeriod: "168h"
	type:          "git-repo"
	url:           "https://github.com/\(_gitRepo)"
}

_gitRepos: [
	"b4b4r07/enhancd",
	"Aloxaf/fzf-tab",
	"romkatv/powerlevel10k",
	"olets/zsh-abbr",
	"jeffreytse/zsh-vi-mode",
]

for gitRepo in _gitRepos {
	"\(regexp.Find("[^/]+$", gitRepo))": #GitRepo & {
		_gitRepo: gitRepo
	}
}

".tmux/plugins/tpm": #GitRepo & {
	_gitRepo: "tmux-plugins/tpm"
}
