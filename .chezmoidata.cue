import (
	"regexp"
	"strings"
)

_os: string | *"" @tag(os,var=os)

aliases: {
	b:   "bat"
	cad: "chezmoi add"
	cat: "bat"
	ca:  "chezmoi apply"
	cr:  "chezmoi re-add"
	cup: "chezmoi update --apply=false; chezmoi init; chezmoi apply"
	ec2: "ssh ec2"
	g:   "git"
	hb:  "hyperfine 'bash -i -c exit'"
	hbn: "hyperfine 'bash --noprofile --norc -i -c exit'"
	j:   "just"
	jd:  "just dev"
	ls:  "lsd"
	l:   "\(ls)"
	la:  "\(ls) -a"
	ll:  "\(ls) -l"
	lla: "\(ls) -la"
	lg:  "lazygit"
	n:   "nvim"
	ni:  "npm install"
	p:   "pnpm"
	pd:  "pnpm dev"
	ppg: "pnpm prisma generate"
	pr:  "gh pr create -f"
	prm: "pnpm remove"
	prr: "\(pr) -r"
	pxi: "pipx install"
	pxu: "pipx uninstall"
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
	}
	_gitAliases: {
		aa:  "add -A"
		c:   "clone"
		ca:  "commit --amend"
		cm:  "commit -m"
		co:  "checkout"
		r:   "rebase"
		rbc: "rebase --continue"
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

	for shAlias, command in {
		for host_prefix, last_octet in {
			dev:       2
			"dev-wsl": 3
			prod:      4
		} {
			"\(host_prefix)": "ssh \(host_prefix)-$(if ncat -z --wait 50ms 192.168.50.\(last_octet) 22; then echo \"local\"; else echo \"remote\"; fi)"
		}

		jsr: #"printf "\e[6 q"; node"#
		tsr: #"printf "\e[6 q"; pnpm tsx"#
	} {
		"\(shAlias)": "sh -c '\(command)'"
	}

	{
		linux: {
			ai:  "sudo apt install"
			ar:  "sudo apt remove"
			fd:  "fd --hidden"
			man: "batman"
			rs:  "rm ~/.local/share/nvim/sessions/*"
			tg:  "topgrade"
			tns: "tmux new-session -A -s"
			tm:  "\(tns) 0"
		}
		windows: {
			chi: "gsudo choco install"
			chs: "choco search"
			chu: "gsudo choco uninstall"
			dpw: #"powershell -c "Invoke-Expression (\"pwsh \" + (New-Object -ComObject WScript.Shell).CreateShortcut(\"\$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk\").Arguments.Replace('\"\"\"', \"'\"))""#
			fd:  "\(linux.fd) --path-separator '//'"
			nrs: "rm $HOME/AppData/Local/nvim-data/sessions/*"
			tg:  "gsudo topgrade"
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
	EDITOR:              "nvim"
	EJSON_KEYDIR:        "$HOME/.config/ejson/keys"
	GH_USERNAME:         "thebengeu"
	NODE_NO_WARNINGS:    "1"
	NVIM_LISTEN_ADDRESS: "127.0.0.1:6789"
	PNPM_HOME:           {
		linux:   "~/.local/share/pnpm"
		windows: "$LOCALAPPDATA\\\\pnpm"
	}[_os]
	RIPGREP_CONFIG_PATH: "$HOME/.ripgreprc"
}
functions: {
	nz: {
		lines: [
			"cd $directory; nvim",
		]
		parameters: ["directory"]
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
					"nix profile remove legacyPackages.x86_64-linux.$package",
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
		"/snap/bin",
		"~/.pulumi/bin",
		"~/.temporalio/bin",
	]
	windows: [
		"/usr/bin",
	]
}[_os]
