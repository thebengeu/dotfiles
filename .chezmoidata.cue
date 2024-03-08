package dotfiles

import (
	"regexp"
	"strings"
)

_arch:     string | *"" @tag(arch,var=arch)
_hostname: string | *"" @tag(hostname,var=hostname)
_os:       string | *"" @tag(os,var=os)
_env:      [if _os == "darwin" {"genv"}, "env"][0]

nonExpandedAliases: {
	l:   "eza --group-directories-first --hyperlink --icons"
	la:  "l --all"
	ll:  "l --git --no-user --long"
	lla: "ll --all"
}

aliases: {
	"-": "cd -"
	b:   "bat"
	brg: "batgrep"
	buz: "brew uninstall --zap"
	cad: "chezmoi add"
	cat: "bat"
	ca:  "chezmoi apply --keep-going --exclude scripts; chezmoi apply --keep-going --include scripts"
	ci:  "cargo binstall --locked --no-confirm"
	cr:  "chezmoi re-add"
	cs:  "glow ~/thebengeu/cheatsheet/README.md"
	csn: "TERM=wezterm nvim ~/thebengeu/cheatsheet/README.md"
	cu:  "cargo uninstall"
	cup: "chezmoi update --apply=false; chezmoi init; \(ca)"
	g:   "git"
	ghd: "gh dash"
	ghp: "gh poi"
	grm: "glow README.md"
	// hb:  "hyperfine 'bash -i -c exit'"
	// hbn: "hyperfine 'bash --noprofile --norc -i -c exit'"
	ic:   "aws ec2-instance-connect ssh --os-user ubuntu --instance-id"
	j:    "just"
	jd:   "just dev"
	lg:   "lazygit"
	man:  "batman"
	n:    "TERM=wezterm nvim"
	nd:   "npm run dev"
	ni:   "npm install"
	nr:   "npm run"
	nrm:  "npm remove"
	p:    "pnpm"
	pi:   "pnpm install"
	pR:   "git push && gh pr create --fill-first && gh pr view --web"
	pr:   "git push && gh pr create --draft --fill-first && gh pr view --web"
	prm:  "pnpm remove"
	prv:  "gh pr view --web"
	pu:   "pnpm uninstall"
	pxi:  "pipx install"
	pxu:  "pipx uninstall"
	rm:   "trash"
	scc:  #"scc --not-match "package-lock.json|pnpm-lock.yaml""#
	nd:   "npm run dev"
	sps:  "supa-ssh"
	spsd: "SUPA_ENV=~/.supa-admin-cli.dev supa-ssh"
	spsl: "SUPA_ENV=~/.supa-admin-cli.local supa-ssh"
	st:   "speedtest"
	t:    "tsx"
	// tb:  "time bash -i -c exit"
	// tbn: "time bash --noprofile --norc -i -c exit"

	// for shellAndFlags, noConfigFlag in {
	// 	"fish --interactive": "--no-config"
	// 	"nu --interactive":   "--no-config-file"
	// 	"powershell":         "-NoProfile"
	// 	"pwsh --interactive": "-NoProfile"
	// 	"zsh --interactive":  "--no-rcs"
	// } {
	// 	let _shell_prefix = "\(regexp.Find("^p?.", shellAndFlags))"
	//
	// 	"h\(_shell_prefix)":  "hyperfine '\(shellAndFlags) -c exit'"
	// 	"h\(_shell_prefix)n": "hyperfine '\(shellAndFlags) \(noConfigFlag) -c exit'"
	// 	"t\(_shell_prefix)":  "time \(shellAndFlags) -c exit"
	// 	"t\(_shell_prefix)n": "time \(shellAndFlags) -\(noConfigFlag) -c exit"
	// }

	{
		_non_windows: {
			fd:  "fd --hidden"
			rns: #"rm -r "$(nvim-stdpath data)/sessions""#
			tg:  "PIP_REQUIRE_VIRTUALENV=false topgrade"
			tns: "tmux new-session -A -s"
			tm:  "\(tns) 0"
		}
		darwin: _non_windows & {
			bbd:          "sh -c 'cd ~/.local/share/chezmoi/ignored && brew bundle dump --file Brewfile --force && git diff Brewfile'"
			bic:          "brew install --cask"
			bif:          "brew info"
			crv:          #"cp ~/Library/Application\ Support/Code/User/keybindings.json ~/.local/share/chezmoi/.chezmoitemplates/code; sed -E 's/(Theme.*").+(",)/\1\2/g' ~/Library/Application\ Support/Code/User/settings.json > ~/.local/share/chezmoi/.chezmoitemplates/code/settings.json"#
			meb:          #"/usr/bin/open -a /Applications/Microsoft\ Edge\ Beta.app --args --proxy-server=in.he.sg:8888"#
			med:          #"/usr/bin/open -a /Applications/Microsoft\ Edge\ Dev.app --args --proxy-server=id.he.sg:8888"#
			supa:         "supa-admin-cli"
			"supa-dev":   "supa-admin-cli --config ~/.supa-admin-cli.dev"
			"supa-local": "supa-admin-cli --config ~/.supa-admin-cli.local"
			wsk:          "wezterm show-keys --lua"
		}
		linux: _non_windows & {
			aar:         "sudo apt autoremove"
			ai:          "sudo apt install"
			ar:          "sudo apt remove"
			ns:          "nix search nixpkgs"
			"xdg-ninja": "nix run github:b3nj5m1n/xdg-ninja"
		}
		windows: {
			chi: "gsudo choco install"
			chs: "choco search"
			chu: "gsudo choco uninstall"
			crv: #"cp ~/AppData/Roaming/Code/User/keybindings.json ~/.local/share/chezmoi/.chezmoitemplates/code; sed -E 's/(Theme.*").+(",)/\1\2/g' ~/AppData/Roaming/Code/User/settings.json > ~/.local/share/chezmoi/.chezmoitemplates/code/settings.json"#
			dpw: #"powershell -c "Invoke-Expression (\"pwsh \" + (New-Object -ComObject WScript.Shell).CreateShortcut(\"\$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk\").Arguments.Replace('\"\"\"', \"'\"))""#
			fd:  "\(_non_windows.fd) --path-separator '//'"
			rns: #"rm -r "$(nvim-stdpath data)\sessions""#
			tg:  "winget upgrade gsudo spotify; gsudo topgrade"
			wsk: "wezterm show-keys --lua"
		}
	}[_os]

	v:        string | *"neovide"
	_neovide: string | *"\(v) -- --cmd"

	if _os == "darwin" {
		_neovide: "open -b com.neovide.neovide --args -- --cmd"
		v:        "\(_neovide) \"cd $PWD\""
	}

	if strings.HasSuffix(_hostname, "-wsl") {
		v: "/mnt/c/Users/beng/scoop/shims/neovide.exe --wsl"
	}

	csv: "\(_neovide) 'cd ~/thebengeu/cheatsheet' ~/thebengeu/cheatsheet/README.md"

	_aliasDirectories: {
		c:  "$HOME/.local/share/chezmoi"
		d:  "$HOME/thebengeu/drakon"
		h:  "$HOME/supabase/helper-scripts"
		i:  "$HOME/supabase/infrastructure"
		s:  "$HOME/sb"
		sb: "$HOME/supabase"
		u:  "$HOME/thebengeu/qmk_userspace"
	}

	for prefix, directory in _aliasDirectories {
		"\(prefix)cd": "cd \(directory)"
		"\(prefix)v":  "\(_neovide) 'cd \(strings.Replace(directory, "$HOME", "~", -1))'"
		"\(prefix)lg": "lazygit --path \(directory)"
		"\(prefix)n":  "TERM=wezterm nvim --cmd 'cd \(strings.Replace(directory, "$HOME", "~", -1))'"
		"\(prefix)rg": "\(_env) --chdir \(strings.Replace(directory, "$HOME", "~", -1)) rg"
	}

	_directoryGitAliases: {
		cam: "commit -a -m"
		d:   "diff"
		l:   "lg"
		lp:  "lg --patch"
		P:   "push"
		p:   "pull"
		pf:  "pf"
		rh:  "reset --hard HEAD"
		s:   "s"
		w:   "wip"
	}
	_gitAliases: {
		aa:  "add -A"
		c:   "clone"
		ca:  "commit --amend"
		cm:  "commit -m"
		pf:  "pf"
		pu:  "pu"
		r:   "rebase"
		rc:  "rebase --continue"
		rru: "remote remove upstream"
		rv:  "remote -v"
		sa:  "stash apply"
		sP:  "stash push"
		sp:  "stash pop"
		sw:  "sw"
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

	for shAlias, command in {
		jsr: #"printf "\e[6 q"; node"#
		tsr: #"printf "\e[6 q"; tsx"#
	} {
		"\(shAlias)": "sh -c '\(command)'"
	}

	for appName in _nvimConfigs {
		"\(appName)": "NVIM_APPNAME=\(appName) TERM=wezterm nvim"
	}

	for packageManager in {
		darwin: [
			"brew",
			"mas",
		]
		linux: []
		windows: [
			"scoop",
			"winget",
		]
	}[_os] {
		for subCommand in ["install", "list", "search", "uninstall"] {
			"\(regexp.Find("^.", packageManager)+regexp.Find("^.", subCommand))": "\(packageManager) \(subCommand)"
		}
	}
}
environmentVariables: {
	AWS_PROFILE:                "supabase-dev"
	BAT_THEME:                  "Catppuccin-mocha"
	DIRENV_LOG_FORMAT:          ""
	DOCKER_CLI_HINTS:           false
	EDITOR:                     "nvim"
	EJSON_KEYDIR:               "$HOME/.config/ejson/keys"
	FZF_DEFAULT_OPTS:           "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
	GH_USERNAME:                "thebengeu"
	GITLINT_CONFIG:             "$HOME/.config/gitlint/gitlint.ini"
	LESS:                       "--quit-if-one-screen --RAW-CONTROL-CHARS"
	MICRO_TRUECOLOR:            1
	PIP_REQUIRE_VIRTUALENV:     true
	PULUMI_SKIP_UPDATE_CHECK:   true
	PYENV_ROOT:                 "$HOME/.pyenv"
	RIPGREP_CONFIG_PATH:        "$HOME/.config/ripgrep/config"
	USQL_SHOW_HOST_INFORMATION: false

	{
		_common: {
			LG_CONFIG_FILE: "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/mocha-lavender.yml"
			PNPM_HOME:      "$HOME/.local/share/pnpm"
		}
		darwin: _common
		linux: _common & {
			FLYCTL_INSTALL: "$HOME/.fly"
		}
		windows: {
			LG_CONFIG_FILE:   "$APPDATA\\\\lazygit\\\\config.yml,$APPDATA\\\\lazygit\\\\mocha-lavender.yml"
			NODE_NO_WARNINGS: 1
			PNPM_HOME:        "$HOME/AppData/Local/pnpm"
		}
	}[_os]
}
functions: {
	md: {
		lines: [
			"mkdir -p \"$directory\"",
			"cd \"$directory\"",
		]
		parameters: ["directory"]
	}
	nz: {
		lines: [
			"cd $directory; TERM=wezterm nvim",
		]
		parameters: ["directory"]
	}
	pp: {
		lines: [
			"tac $log_file | pino-pretty --colorize --translateTime 'yyyy-mm-dd HH:MM:ss' | less",
		]
		parameters: ["log_file"]
	}
	sic: {
		lines: [
			#"aws ec2-instance-connect ssh --instance-id $(aws ec2 describe-instances --filters "Name=tag:Name,Values=*-db-$id" --output text --query 'Reservations[*].Instances[*].InstanceId') --os-user ubuntu"#,
		]
		parameters: ["id"]
	}

	{
		darwin: {}
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
_windows_arm64_paths: [...string]
if _hostname == "surface" {
	_windows_arm64_paths: [
		#"/c/Program\ Files/Microsoft\ Visual\ Studio/2022/Community/VC/Tools/Llvm/ARM64/bin"#,
	]
}
_wsl_paths: [...string]
if strings.HasSuffix(_hostname, "-wsl") {
	_wsl_paths: [
		"/mnt/c/Program\\ Files/Neovide",
		"/mnt/c/Program\\ Files\\ \\(x86\\)/nvim/bin",
	]
}
paths: [
	"$PNPM_HOME",
	"~/.cargo/bin",
	"~/.local/bin",
	"~/git-fuzzy/bin",
	"~/go/bin",
	"~/thebengeu/scripts",
] + {
	darwin: [
		"~/Library/Python/3.11/bin",
		"/opt/homebrew/opt/curl/bin",
		"/usr/local/bin",
	]
	linux: [
		"/snap/aws-cli/current/bin",
		"/snap/bin",
		"~/.pulumi/bin",
		"~/.temporalio/bin",
		"$FLYCTL_INSTALL/bin",
		"$PYENV_ROOT/bin",
	] + _wsl_paths
	windows: [
		"~/AppData/Roaming/Python/Python312/Scripts",
		"/usr/bin",
	] + _windows_arm64_paths
}[_os]
