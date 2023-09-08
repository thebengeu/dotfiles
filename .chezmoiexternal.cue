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
	"agkozak/agkozak-zsh-prompt",
	"zdharma-continuum/fast-syntax-highlighting",
	"zdharma-continuum/history-search-multi-word",
	"zsh-users/zsh-autosuggestions",
	"zsh-users/zsh-completions",
	"zsh-users/zsh-history-substring-search",
]

for gitRepo in _gitRepos {
	".config/zsh/\(regexp.Find("[^/]+$", gitRepo))": #GitRepo & {
		_gitRepo: gitRepo
	}
}

".tmux/plugins/tpm": #GitRepo & {
	_gitRepo: "tmux-plugins/tpm"
}
