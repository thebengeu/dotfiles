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

".config/fish/completions/nvr.fish": #File & {
	url: "https://raw.githubusercontent.com/mhinz/neovim-remote/master/contrib/completion.fish"
}
".config/fish/completions/tldr.fish": #File & {
	url: "https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/fish_tealdeer"
}
".config/git/template/hooks/add-upstream-auto-detected-url.sh": #ExecutableFile & {
	url: "https://raw.githubusercontent.com/thebengeu/auto-git-remote-add-upstream/master/add-upstream-auto-detected-url.sh"
}
".config/git/template/hooks/post-checkout": #ExecutableFile & {
	url: "https://raw.githubusercontent.com/thebengeu/auto-git-remote-add-upstream/master/post-checkout"
}
".local/bin/batman": #ArchiveFile & {
	executable: true
	path:       "bin/batman"
	url:        "https://github.com/eth-p/bat-extras/releases/download/v2023.09.19/bat-extras-202309.19.zip"
}
".local/bin/batgrep": #ArchiveFile & {
	executable: true
	path:       "bin/batgrep"
	url:        "https://github.com/eth-p/bat-extras/releases/download/v2023.09.19/bat-extras-202309.19.zip"
}
".local/bin/cht": #ExecutableFile & {
	url: "https://cht.sh/:cht.sh"
}

{
	linux: {
		".config/tmux/plugins/tpm": #GitRepo & {
			_gitRepo: "tmux-plugins/tpm"
		}
		".local/bin/lmn": #ArchiveFile & {
			path: "lemonade"
			url:  "https://github.com/lemonade-command/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz"
		}
	}
	windows: {
		".config/fish/completions/bat.fish": #ArchiveFile & {
			path:            "autocomplete/bat.fish"
			stripComponents: 1
			url:             "https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-x86_64-unknown-linux-musl.tar.gz"
		}
		".config/fish/completions/lsd.fish": #ArchiveFile & {
			path:            "autocomplete/lsd.fish"
			stripComponents: 1
			url:             "https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-musl.tar.gz"
		}
		".config/fish/completions/rg.fish": #ArchiveFile & {
			path:            "complete/rg.fish"
			stripComponents: 1
			url:             "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz"
		}
		".local/bin/config.txt": #ArchiveFile & {
			path:            "config.txt"
			stripComponents: 1
			url:             "https://github.com/ililim/dual-key-remap/releases/download/v0.7/dual-key-remap-v0.7.zip"
		}
		".local/bin/dual-key-remap.exe": #ArchiveFile & {
			path:            "dual-key-remap.exe"
			stripComponents: 1
			url:             "https://github.com/ililim/dual-key-remap/releases/download/v0.7/dual-key-remap-v0.7.zip"
		}
		".local/bin/lmn.exe": #ArchiveFile & {
			path: "lemonade.exe"
			url:  "https://github.com/lemonade-command/lemonade/releases/download/v1.1.1/lemonade_windows_amd64.zip"
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
