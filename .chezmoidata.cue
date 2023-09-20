import (
	"regexp"
	"strings"
)

_os: string | *"" @tag(os,var=os)

_aliasDirectories: {
	c: "$HOME/.local/share/chezmoi"
	d: "$HOME/thebengeu/drakon"
}
_directoryGitAliases: {
	cam: "commit -a -m"
	d:   "diff"
	l:   "lg"
	lp:  "lg --patch"
	P:   "push"
	p:   "pull"
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
	rhh: "reset --hard HEAD"
	rru: "remote remove upstream"
	rv:  "remote -v"
	sa:  "stash apply"
	sP:  "stash push"
	sp:  "stash pop"
}
_shAliases: {
	_hosts: {
		dev:       2
		"dev-wsl": 3
		prod:      4
	}

	for alias_prefix, last_octet in _hosts {
		"\(alias_prefix)": #"ssh \(alias_prefix)-$(if ncat -z --wait 50ms 192.168.50.\(last_octet) 22; then echo "local"; else echo "remote"; fi)"#
	}

	jsr: #"printf "\e[6 q"; node"#
	tsr: #"printf "\e[6 q"; pnpm tsx"#
}
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
	l:   "lsd"
	la:  "lsd -a"
	ll:  "lsd -l"
	lla: "lsd -la"
	ls:  "lsd"
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

	_noConfigFlags: {
		"fish --interactive": "--no-config"
		"nu --interactive":   "--no-config-file"
		"powershell":         "-NoProfile"
		"pwsh --interactive": "-NoProfile"
		"zsh --interactive":  "--no-rcs"
	}
	for shellAndFlags, noConfigFlag in _noConfigFlags {
		"h\(regexp.Find("^p?.", shellAndFlags))":  "hyperfine '\(shellAndFlags) -c exit'"
		"h\(regexp.Find("^p?.", shellAndFlags))n": "hyperfine '\(shellAndFlags) \(noConfigFlag) -c exit'"
		"t\(regexp.Find("^p?.", shellAndFlags))":  "time \(shellAndFlags) -c exit"
		"t\(regexp.Find("^p?.", shellAndFlags))n": "time \(shellAndFlags) -\(noConfigFlag) -c exit"
	}

	for prefix, directory in _aliasDirectories {
		"\(prefix)cd": "cd \(directory)"
		"\(prefix)lg": "lazygit --path \(directory)"
		"\(prefix)n":  "nvim --cmd 'cd \(strings.Replace(directory, "$HOME", "~", -1))'"
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

	for shAlias, command in _shAliases {
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
			tm:  "tmux new-session -A -s 0"
			tns: "tmux new-session -A -s"
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
	EDITOR:           "nvim"
	EJSON_KEYDIR:     "$HOME/.config/ejson/keys"
	GH_USERNAME:      "thebengeu"
	NODE_NO_WARNINGS: "1"
	PNPM_HOME:        {
		linux:   "~/.local/share/pnpm"
		windows: "$LOCALAPPDATA\\pnpm"
	}[_os]
	RIPGREP_CONFIG_PATH: "$HOME/.ripgreprc"
}
functions: {
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
	nz: {
		lines: [
			"cd $directory; nvim",
		]
		parameters: ["directory"]
	}
	wcss: {
		lines: [
			"parallel {} search $package ::: choco scoop winget",
		]
		parameters: ["package"]
	}
}
paths: [
	"/snap/bin",
	"/usr/bin",
	"~/.cargo/bin",
	"~/.local/bin",
	"~/.pulumi/bin",
	"~/.temporalio/bin",
	"~/go/bin",
	"$PNPM_HOME",
]
