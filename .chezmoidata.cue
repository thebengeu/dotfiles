package dotfiles

import (
	"regexp"
	"strings"
)

_arch:     string | *"" @tag(arch,var=arch)
_hostname: string | *"" @tag(hostname,var=hostname)
_os:       string | *"" @tag(os,var=os)

nonExpandedAliases: {
	l:   "eza --group-directories-first --hyperlink --icons"
	la:  "\(l) --all"
	ll:  "\(l) --git --no-user --long"
	lla: "\(ll) --all"
}

aliases: {
	"-": "cd -"
	b:   "bat"
	brg: "batgrep"
	cad: "chezmoi add"
	cat: "bat"
	ca:  "chezmoi apply --exclude scripts; chezmoi apply --include scripts"
	cr:  "chezmoi re-add"
	cup: "chezmoi update --apply=false; chezmoi init; \(ca)"
	g:   "git"
	hb:  "hyperfine 'bash -i -c exit'"
	hbn: "hyperfine 'bash --noprofile --norc -i -c exit'"
	j:   "just"
	jd:  "just dev"
	lg:  "lazygit"
	man: "batman"
	n:   "nvim"
	ni:  "npm install"
	p:   "pnpm"
	pr:  "gh pr create -f"
	prm: "pnpm remove"
	prr: "\(pr) -r"
	pxi: "pipx install"
	pxu: "pipx uninstall"
	rm:  "trash"
	scc: #"scc --not-match "package-lock.json|pnpm-lock.yaml""#
	tb:  "time bash -i -c exit"
	tbn: "time bash --noprofile --norc -i -c exit"
	t:   "pnpm tsx"
	vim: "nvim"

	for shellAndFlags, noConfigFlag in {
		"fish --interactive": "--no-config"
		"nu --interactive":   "--no-config-file"
		"powershell":         "-NoProfile"
		"pwsh --interactive": "-NoProfile"
		"zsh --interactive":  "--no-rcs"
	} {
		let _shell_prefix = "\(regexp.Find("^p?.", shellAndFlags))"

		"h\(_shell_prefix)":  "hyperfine '\(shellAndFlags) -c exit'"
		"h\(_shell_prefix)n": "hyperfine '\(shellAndFlags) \(noConfigFlag) -c exit'"
		"t\(_shell_prefix)":  "time \(shellAndFlags) -c exit"
		"t\(_shell_prefix)n": "time \(shellAndFlags) -\(noConfigFlag) -c exit"
	}

	_aliasDirectories: {
		c: "$HOME/.local/share/chezmoi"
		d: "$HOME/thebengeu/drakon"
	}

	for prefix, directory in _aliasDirectories {
		"\(prefix)cd": "cd \(directory)"
		"\(prefix)lg": "lazygit --path \(directory)"
		"\(prefix)n":  "nvim --cmd 'cd \(strings.Replace(directory, "$HOME", "~", -1))'"
	}

	_directoryGitAliases: {
		cam: "commit -a -m"
		d:   "diff"
		l:   "lg"
		lp:  "lg --patch"
		P:   "push"
		p:   "pull"
		rh:  "reset --hard HEAD"
		s:   "s"
		w:   "wip"
	}
	_gitAliases: {
		aa:  "add -A"
		c:   "clone"
		ca:  "commit --amend"
		cm:  "commit -m"
		co:  "checkout"
		r:   "rebase"
		rc:  "rebase --continue"
		rru: "remote remove upstream"
		rv:  "remote -v"
		sa:  "stash apply"
		sP:  "stash push"
		sp:  "stash pop"
	}

	for gitAlias, command in _directoryGitAliases & _gitAliases {
		"g\(gitAlias)": "git \(command)"
	}
	for prefix, directory in _aliasDirectories {
		"\(prefix)g": "git -C \(directory)"
		for directoryGitAlias, command in _directoryGitAliases {
			"\(prefix)g\(directoryGitAlias)": "git -C \(directory) \(command)"
		}
	}

	for hostname in ["dev", "dev-wsl", "ec2", "prod"] {
		"\(hostname)": "ssh \(hostname)"
	}

	_ssh_command:  "'ssh dev.local'"
	_tmux_command: "tmux new-session -A -s dev \(_ssh_command) \\; set-option default-command \(_ssh_command)"

	if _hostname == "dev" {
		"dev-tmux": "wsl --exec \(_tmux_command)"
	}
	if _hostname == "dev-wsl" {
		"dev-tmux": _tmux_command
	}
	if _hostname != "dev" && _hostname != "dev-wsl" {
		"dev-tmux": "ssh -t dev-wsl \"\(_tmux_command)\""
	}

	for shAlias, command in {
		jsr: #"printf "\e[6 q"; node"#
		tsr: #"printf "\e[6 q"; pnpm tsx"#
	} {
		"\(shAlias)": "sh -c '\(command)'"
	}

	for appName in _nvimConfigs {
		"\(appName)": "NVIM_APPNAME=\(appName) nvim"
	}

	{
		linux: {
			aar:         "sudo apt autoremove"
			ai:          "sudo apt install"
			ar:          "sudo apt remove"
			fd:          "fd --hidden"
			rns:         "rm ~/.local/share/nvim/sessions/*"
			tg:          "topgrade"
			tns:         "tmux new-session -A -s"
			tm:          "\(tns) 0"
			"xdg-ninja": "nix run github:b3nj5m1n/xdg-ninja"
		}
		windows: {
			chi: "gsudo choco install"
			chs: "choco search"
			chu: "gsudo choco uninstall"
			dpw: #"powershell -c "Invoke-Expression (\"pwsh \" + (New-Object -ComObject WScript.Shell).CreateShortcut(\"\$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk\").Arguments.Replace('\"\"\"', \"'\"))""#
			fd:  "\(linux.fd) --path-separator '//'"
			rns: "rm $HOME/AppData/Local/nvim-data/sessions/*"
			tg:  "winget upgrade spotify; gsudo topgrade"
			wsk: "wezterm show-keys --lua"
		}
	}[_os]

	for packageManager in {
		linux: [
			"cargo",
			"pnpm",
		]
		windows: linux + [
				"scoop",
				"winget",
		]
	}[_os] {
		for subCommand in ["install", "search", "uninstall"] {
			"\(regexp.Find("^.", packageManager)+regexp.Find("^.", subCommand))": "\(packageManager) \(subCommand)"
		}
	}
}
environmentVariables: {
	BAT_THEME:           "Catppuccin-mocha"
	DIRENV_LOG_FORMAT:   ""
	EDITOR:              "nvim"
	EJSON_KEYDIR:        "$HOME/.config/ejson/keys"
	FZF_DEFAULT_OPTS:    "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
	GH_USERNAME:         "thebengeu"
	RIPGREP_CONFIG_PATH: "$HOME/.config/ripgrep/config"

	{
		linux: {
			LG_CONFIG_FILE: "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/mocha-lavender.yml"
			PNPM_HOME:      "~/.local/share/pnpm"
		}
		windows: {
			LG_CONFIG_FILE: "$APPDATA\\\\lazygit\\\\config.yml,$APPDATA\\\\lazygit\\\\mocha-lavender.yml"
			PNPM_HOME:      "$LOCALAPPDATA\\\\pnpm"
		}
	}[_os]
}
functions: {
	nz: {
		lines: [
			"cd $directory; nvim",
		]
		parameters: ["directory"]
	}
	pp: {
		lines: [
			"tac $log_file | pino-pretty --colorize --translateTime 'yyyy-mm-dd HH:MM:ss' | less",
		]
		parameters: ["log_file"]
	}

	{
		linux: {
			npi: {
				lines: [
					"nix profile install nixpkgs#$package",
				]
				parameters: ["package"]
			}
			npr: {
				lines: [
					"nix profile remove legacyPackages.\({amd64: "x86_64", arm64: "aarch64"}[_arch])-linux.$package",
				]
				parameters: ["package"]
			}
		}
		windows: {
			wcss: {
				lines: [
					"parallel {} search $package ::: choco scoop winget",
				]
				parameters: ["package"]
			}
		}
	}[_os]
}
paths: [
	"~/.cargo/bin",
	"~/.local/bin",
	"~/go/bin",
	"$PNPM_HOME",
] + {
	linux: [
		"/snap/aws-cli/current/bin",
		"/snap/bin",
		"~/.pulumi/bin",
		"~/.temporalio/bin",
	]
	windows: [
		"/usr/bin",
	]
}[_os]
