import "strings"

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
	bi:   "brew install"
	bui:  "brew uninstall"
	cat:  "bat"
	ca:   "chezmoi apply"
	ci:   "choco install"
	cr:   "chezmoi re-add"
	cs:   "choco search"
	cu:   "choco uninstall"
	ec2:  "ssh -t ec2 tmux new-session -A -s 0"
	g:    "git"
	j:    "just"
	jd:   "just dev"
	l:    "lsd"
	la:   "lsd -a"
	ll:   "lsd -l"
	lla:  "lsd -la"
	lg:   "lazygit"
	n:    "nvim"
	p:    "pnpm"
	pd:   "pnpm dev"
	pi:   "pnpm i"
	pp:   "psql postgresql://postgres:postgres@localhost:5432/postgres"
	ppg:  "pnpm prisma generate"
	pr:   "gh pr create -f"
	prm:  "pnpm rm"
	prod: "ssh -t prod tmux new-session -A -s 0"
	prr:  "gh pr create -f -r"
	rg:   "rg --max-columns 1000"
	scc:  "scc --not-match \"package-lock.json|pnpm-lock.yaml\""
	si:   "scoop install"
	ss:   "scoop search"
	su:   "scoop uninstall"
	tg:   "pwsh -Command gsudo topgrade"
	tns:  "tmux new-session -A -s"
	tsx:  "pnpm tsx"
	vim:  "nvim"
	wi:   "winget install"
	ws:   "winget search"
	wu:   "winget uninstall"

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
functions: wcss: {
	body: [
		"winget search $package",
		"choco search $package",
		"scoop search $package",
	]
	parameters: ["package"]
}
