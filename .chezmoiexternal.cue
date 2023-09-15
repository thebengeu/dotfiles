import "regexp"

#External: {
	executable?: bool
	type:        "archive" | "file" | "git-repo"
	url:         string
}

#GitRepo: {
	#External
	_gitRepo:      string
	refreshPeriod: "168h"
	type:          "git-repo"
	url:           "https://github.com/\(_gitRepo)"
}

_zshGitRepos: [
	"Aloxaf/fzf-tab",
	"agkozak/agkozak-zsh-prompt",
	"zdharma-continuum/fast-syntax-highlighting",
	"zdharma-continuum/history-search-multi-word",
	"zsh-users/zsh-autosuggestions",
	"zsh-users/zsh-completions",
	"zsh-users/zsh-history-substring-search",
]

for gitRepo in _zshGitRepos {
	".config/zsh/\(regexp.Find("[^/]+$", gitRepo))": #GitRepo & {
		_gitRepo: gitRepo
	}
}

".config/git/template/hooks/add-upstream-auto-detected-url.sh": #External & {
	executable: true
	type:       "file"
	url:        "https://raw.githubusercontent.com/thebengeu/auto-git-remote-add-upstream/master/add-upstream-auto-detected-url.sh"
}
".config/tmux/plugins/tpm": #GitRepo & {
	_gitRepo: "tmux-plugins/tpm"
}
".local/bin": {
	include: [ "*/config.txt", "*/dual-key-remap.exe"]
	stripComponents: 1
	type:            "archive"
	url:             "https://github.com/ililim/dual-key-remap/releases/download/v0.7/dual-key-remap-v0.7.zip"
}
