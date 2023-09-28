package dotfiles

import (
	"regexp"
)

for gitRepo, appName in _nvimConfigs {
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

_broot_config_home: {
	linux:   "broot"
	windows: "dystroy/broot/config"
}[_os]

"\(_xdgConfigHomeRoaming)/\(_broot_config_home)/skins/catppuccin-mocha.hjson": #File & {
	url: "https://raw.githubusercontent.com/Canop/broot/main/resources/default-conf/skins/catppuccin-mocha.hjson"
}

_btop_config_home: {
	linux:   "snap/btop/655/.config"
	windows: "scoop/persist"
}[_os]

"\(_btop_config_home)/btop/themes/catppuccin_mocha.theme": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme"
}

"\(_xdgConfigHomeRoaming)/lazygit/mocha-lavender.yml": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/lazygit/main/themes-mergable/mocha/mocha-lavender.yml"
}
