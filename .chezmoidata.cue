import (
	"regexp"
	"strings"
)

_aliasDirectories: {
	c: "$HOME/.local/share/chezmoi"
	d: "$HOME/thebengeu/drakon"
}
_gitAliases: {
	aa:  "add -A"
	c:   "clone"
	ca:  "commit --amend"
	cam: "commit -a -m"
	cm:  "commit -m"
	co:  "checkout"
	d:   "diff"
	l:   "lg"
	lp:  "lg --patch"
	P:   "push"
	p:   "pull"
	r:   "rebase"
	rbc: "rebase --continue"
	rhh: "reset --hard HEAD"
	rru: "remote remove upstream"
	rv:  "remote -v"
	s:   "s"
	sa:  "stash apply"
	sP:  "stash push"
	sp:  "stash pop"
}
_shAliases: {
	dev:  #"ssh dev-$(if ncat -z --wait 100ms 192.168.50.2 22; then echo "local"; else echo "remote"; fi)"#
	nr:   #"printf "\e[6 q"; node"#
	tsxr: #"printf "\e[6 q"; pnpm tsx"#
}
aliases: {
	b:    "bat"
	cad:  "chezmoi add"
	cat:  "bat"
	ca:   "chezmoi apply --init"
	cht:  "cht.sh"
	cr:   "chezmoi re-add"
	cup:  "chezmoi update --apply --init"
	ec2:  "ssh -t ec2 tmux new-session -A -s 0"
	g:    "git"
	hb:   "hyperfine 'bash -i -c exit'"
	hbn:  "hyperfine 'bash --noprofile --norc -i -c exit'"
	j:    "just"
	jd:   "just dev"
	l:    "lsd"
	la:   "lsd -a"
	ll:   "lsd -l"
	lla:  "lsd -la"
	ls:   "lsd"
	lg:   "lazygit"
	n:    "nvim"
	p:    "pnpm"
	pd:   "pnpm dev"
	ppg:  "pnpm prisma generate"
	pr:   "gh pr create -f"
	prm:  "pnpm remove"
	prod: "ssh -t prod tmux new-session -A -s 0"
	prr:  "gh pr create -f -r"
	scc:  "scc --not-match \"package-lock.json|pnpm-lock.yaml\""
	tb:   "time bash -i -c exit"
	tbn:  "time bash --noprofile --norc -i -c exit"
	tns:  "tmux new-session -A -s"
	t:    "pnpm tsx"
	vim:  "nvim"

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

	for gitAlias, command in _gitAliases {
		"g\(gitAlias)": "git \(command)"
		for prefix, directory in _aliasDirectories {
			"\(prefix)g\(gitAlias)": "git -C \(directory) \(command)"
		}
	}

	for shAlias, command in _shAliases {
		"\(shAlias)": "sh -c '\(command)'"
	}
}
_packageManagers: {
	linux: [
		"pnpm",
	]
	windows: [
		"choco",
		"pnpm",
		"scoop",
		"winget",
	]
}
platformSpecificAliases: {
	linux: {
		fd: "fd --hidden"
		tg: "topgrade"
	}
	windows: {
		fd: "fd --hidden --path-separator '//'"
		tg: "powershell -NoProfile -Command gsudo topgrade"
	}

	for os, packageManagers in _packageManagers {
		"\(os)": {
			for packageManager in packageManagers {
				for subCommand in ["install", "search", "uninstall"] {
					"\(regexp.Find("^.", packageManager)+regexp.Find("^.", subCommand))": "\(packageManager) \(subCommand)"
				}
			}
		}
	}
}
environmentVariables: {
	EDITOR:              "nvim"
	EJSON_KEYDIR:        "$HOME/.config/ejson/keys"
	NODE_NO_WARNINGS:    "1"
	RIPGREP_CONFIG_PATH: "$HOME/.ripgreprc"
}
functions: wcss: {
	lines: [
		"parallel {} search $package ::: choco scoop winget",
	]
	parameters: ["package"]
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
