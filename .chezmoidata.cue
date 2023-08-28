import (
	"regexp"
	"strings"
)

_aliasDirectories: {
	c: "$HOME/.local/share/chezmoi"
	d: "$HOME/drakon"
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
	ez:   "exec zsh"
	fd:   "fd --hidden"
	g:    "git"
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
	pp:   "psql postgresql://postgres:postgres@localhost:5432/postgres"
	ppg:  "pnpm prisma generate"
	pr:   "gh pr create -f"
	prod: "ssh -t prod tmux new-session -A -s 0"
	prr:  "gh pr create -f -r"
	scc:  "scc --not-match \"package-lock.json|pnpm-lock.yaml\""
	tg:   "pwsh -Command gsudo topgrade"
	tns:  "tmux new-session -A -s"
	tsx:  "pnpm tsx"
	vim:  "nvim"

	_noConfigArguments: {
		fish: "--no-config"
		nu:   "--no-config-file"
		pwsh: "-NoProfile"
		zsh:  "--no-rcs"
	}
	for shell, noConfigArgument in _noConfigArguments {
		"h\(regexp.Find("^.", shell))":  "hyperfine --shell sh 'time \(shell) --interactive -c exit'"
		"h\(regexp.Find("^.", shell))n": "hyperfine --shell sh 'time \(shell) --interactive \(noConfigArgument) -c exit'"
		"t\(regexp.Find("^.", shell))":  "time \(shell) --interactive -c exit"
		"t\(regexp.Find("^.", shell))n": "time \(shell) --interactive -\(noConfigArgument) -c exit"
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
		#"sh -c "C:/msys64/usr/bin/parallel {} search $package ::: choco scoop winget""#,
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
