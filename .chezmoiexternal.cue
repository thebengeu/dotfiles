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
	"b4b4r07/enhancd",
	"hlissner/zsh-autopair",
	"jeffreytse/zsh-vi-mode",
	"olets/zsh-abbr",
	"romkatv/powerlevel10k",
	"romkatv/zsh-defer",
	"woefe/git-prompt.zsh",
	"zdharma-continuum/fast-syntax-highlighting",
	"zdharma-continuum/history-search-multi-word",
	"zsh-users/zsh-autosuggestions",
	"zsh-users/zsh-completions",
	"zsh-users/zsh-history-substring-search",
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
