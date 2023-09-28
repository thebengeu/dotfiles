import (
	"regexp"
	"strings"
	"github.com/thebengeu/dotfiles/common"
)

#External: {
	executable?:      bool
	path?:            string
	stripComponents?: number
	type:             "archive-file" | "file" | "git-repo"
	url:              string
}

#File: {
	#External
	type: "file"
}

#ExecutableFile: {
	#File
	executable: true
}

#GitRepo: {
	#External
	_gitRepo:      string
	refreshPeriod: "168h"
	type:          "git-repo"
	url:           "https://github.com/\(_gitRepo)"
}

_os: string | *"" @tag(os,var=os)

#XdgConfigHome: {
	_localOrRoaming: "Local" | "Roaming"
	linux:           ".config"
	windows:         "AppData/\(_localOrRoaming)"
}
_xdgConfigHomeLocal: (#XdgConfigHome & {
	_localOrRoaming: "Local"
})[_os]
_xdgConfigHomeRoaming: (#XdgConfigHome & {
	_localOrRoaming: "Roaming"
})[_os]

for gitRepo, appName in common.nvimConfigs {
	"\(_xdgConfigHomeLocal)/\(appName)": #GitRepo & {
		_gitRepo: gitRepo
	}
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

".config/git/template/hooks/add-upstream-auto-detected-url.sh": #ExecutableFile & {
	url: "https://raw.githubusercontent.com/thebengeu/auto-git-remote-add-upstream/master/add-upstream-auto-detected-url.sh"
}
".config/git/template/hooks/post-checkout": #ExecutableFile & {
	url: "https://raw.githubusercontent.com/thebengeu/auto-git-remote-add-upstream/master/post-checkout"
}
".local/bin/cht": #ExecutableFile & {
	url: "https://cht.sh/:cht.sh"
}
".config/fish/completions/nvr.fish": #File & {
	url: "https://raw.githubusercontent.com/mhinz/neovim-remote/master/contrib/completion.fish"
}

{
	linux: {
		".config/tmux/plugins/tpm": #GitRepo & {
			_gitRepo: "tmux-plugins/tpm"
		}
		".local/bin/lmn": {
			path: "lemonade"
			type: "archive-file"
			url:  "https://github.com/lemonade-command/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz"
		}
	}
	windows: {
		".local/bin/config.txt": #External & {
			path:            "config.txt"
			stripComponents: 1
			type:            "archive-file"
			url:             "https://github.com/ililim/dual-key-remap/releases/download/v0.7/dual-key-remap-v0.7.zip"
		}
		".local/bin/dual-key-remap.exe": #External & {
			executable:      true
			path:            "dual-key-remap.exe"
			stripComponents: 1
			type:            "archive-file"
			url:             "https://github.com/ililim/dual-key-remap/releases/download/v0.7/dual-key-remap-v0.7.zip"
		}
		".local/bin/lmn.exe": #External & {
			executable: true
			path:       "lemonade.exe"
			type:       "archive-file"
			url:        "https://github.com/lemonade-command/lemonade/releases/download/v1.1.1/lemonade_windows_amd64.zip"
		}
	}
}[_os]

"\(_xdgConfigHomeRoaming)/bat/themes/Catppuccin-mocha.tmTheme": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme"
}
