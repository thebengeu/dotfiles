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
	"jeffreytse/zsh-vi-mode",
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
".config/gitui/theme.ron": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/gitui/main/themes/catppuccin-mocha.ron"
}
".config/micro/colorschemes/catppuccin-mocha.micro": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-mocha.micro"
}
".local/bin/cht": #ExecutableFile & {
	url: "https://cht.sh/:cht.sh"
}
"repos/git-fuzzy": #GitRepo & {
	_gitRepo: "bigH/git-fuzzy"
}
"repos/neovide": #GitRepo & {
	_gitRepo: "neovide/neovide"
}

{
	darwin: {
		".config/tmux/plugins/tpm": #GitRepo & {
			_gitRepo: "tmux-plugins/tpm"
		}
		".config/kitty/neighboring_window.py": #File & {
			url: "https://raw.githubusercontent.com/mrjones2014/smart-splits.nvim/master/kitty/neighboring_window.py"
		}
		".config/kitty/relative_resize.py": #File & {
			url: "https://raw.githubusercontent.com/mrjones2014/smart-splits.nvim/master/kitty/relative_resize.py"
		}
	}
	linux: darwin & {
		".local/bin/lmn": #ArchiveFile & {
			path: "lemonade"
			url:  "https://github.com/lemonade-command/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz"
		}
	}
	windows: {
		".config/fish/completions/bat.fish": #ArchiveFile & {
			path:            "autocomplete/bat.fish"
			stripComponents: 1
			url:             "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz"
		}
		".local": #Archive & {
			include: ["bin/protoc.exe", "include/**"]
			url: "https://github.com/protocolbuffers/protobuf/releases/download/v28.1/protoc-28.1-win64.zip"
		}
		".local/bin/lmn.exe": #ArchiveFile & {
			path: "lemonade.exe"
			url:  "https://github.com/lemonade-command/lemonade/releases/download/v1.1.1/lemonade_windows_amd64.zip"
		}
	}
}[_os]

if _os != "darwin" {
	".config/fish/completions/eza.fish": #File & {
		url: "https://raw.githubusercontent.com/eza-community/eza/main/completions/fish/eza.fish"
	}
	".config/fish/completions/tldr.fish": #File & {
		url: "https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/fish_tealdeer"
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

}

_broot_config_home: {
	darwin:  "broot"
	linux:   "broot"
	windows: "dystroy/broot/config"
}[_os]

"\(_xdgConfigHomeRoaming)/\(_broot_config_home)/skins/catppuccin-mocha.hjson": #File & {
	url: "https://raw.githubusercontent.com/Canop/broot/main/resources/default-conf/skins/catppuccin-mocha.hjson"
}

_btop_config_home: {
	darwin:  ".config"
	linux:   ".config"
	windows: "scoop/persist"
}[_os]

"\(_btop_config_home)/btop/themes/catppuccin_mocha.theme": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme"
}

"\(_xdgConfigHomeRoaming)/lazygit/mocha-lavender.yml": #File & {
	url: "https://raw.githubusercontent.com/catppuccin/lazygit/main/themes-mergable/mocha/lavender.yml"
}
