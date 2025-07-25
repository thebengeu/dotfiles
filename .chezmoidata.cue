package dotfiles

import (
	"list"
	"regexp"
	"strings"
)

_arch:     string | *"" @tag(arch,var=arch)
_hostname: string | *"" @tag(hostname,var=hostname)
_os:       string | *"" @tag(os,var=os)
_env: [if _os == "darwin" {"genv"}, "env"][0]
_colabPort: [if _hostname == "hc" {"9002"}, "9000"][0]

nonExpandedAliases: {
	l:   "eza --group-directories-first --hyperlink --icons"
	la:  "l --all"
	ll:  "l --git --no-user --long"
	lla: "ll --all"
}

aliases: {
	"-":             "cd -"
	afs1:            "export AWS_REGION=af-south-1;"
	apne1:           "export AWS_REGION=ap-northeast-1;"
	apne2:           "export AWS_REGION=ap-northeast-2;"
	apne3:           "export AWS_REGION=ap-northeast-3;"
	ape1:            "export AWS_REGION=ap-east-1;"
	aps1:            "export AWS_REGION=ap-south-1;"
	aps2:            "export AWS_REGION=ap-south-2;"
	apse1:           "export AWS_REGION=ap-southeast-1;"
	apse2:           "export AWS_REGION=ap-southeast-2;"
	apse3:           "export AWS_REGION=ap-southeast-3;"
	apse4:           "export AWS_REGION=ap-southeast-4;"
	apse5:           "export AWS_REGION=ap-southeast-5;"
	bd:              "brew doctor"
	bf:              "\(_env) --chdir ~/thebengeu/qmk_userspace make hazel/bad_wings:thebengeu:flash"
	cf:              "\(_env) --chdir ~/thebengeu/qmk_userspace make bastardkb/charybdis/4x6:thebengeu:flash"
	bm:              "batman"
	bgw:             "aws-vault exec --no-session bedrock -- docker run --detach --env AWS_REGION=us-east-1 --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --name bedrock-gateway --publish 2337:80 --restart unless-stopped ibehren1/bedrock-gateway"
	c:               "docker compose"
	ca:              "chezmoi apply --keep-going --exclude scripts; chezmoi apply --keep-going --include scripts"
	cad:             "chezmoi add"
	cat:             "bat"
	ci:              "cargo binstall --locked --no-confirm"
	cl:              "docker compose logs --follow"
	clx:             "clx --nerdfonts"
	clc:             "docker start colab && sleep 3 && docker logs colab | jn-url 9000 \(_colabPort) | osc copy"
	clr:             "docker run --detach --name colab --publish 127.0.0.1:9000:8080 asia-docker.pkg.dev/colab-images/public/runtime"
	cpd:             "docker compose --profile '*' down"
	cr:              "docker compose restart --no-deps"
	cra:             "chezmoi re-add"
	_cheatsheetPath: "~/thebengeu/cheatsheet/README.md"
	cs:              "glow \(_cheatsheetPath)"
	csn:             "nvim \(_cheatsheetPath)"
	cu:              "cargo uninstall"
	cup:             "chezmoi update --apply=false; chezmoi init; \(ca)"
	cx:              "chmod +x"
	d:               "devspace"
	dc:              "supa-admin-cli --config ~/.supa-admin-cli.dev"
	dh:              "\(dc) ssh -p"
	dp:              "\(dc) psql --disable-statement-tracking -p"
	dpu:             "AWS_PROFILE=supabase-dev pulumi up --stack supabase/staging"
	ds:              "docker stats"
	dsp:             "docker system prune --force --volumes"
	dspa:            "\(dsp) --all"
	e:               "echo"
	ep:              "echo ${PATH}"
	g:               "git"
	gap:             "git all pull"
	ghd:             "gh dash"
	gn:              "eksctl get nodegroup --cluster $(eks-cluster-name)"
	grm:             "glow README.md"
	hb:              "hyperfine 'bash -i -c exit'"
	hbn:             "hyperfine 'bash --noprofile --norc -i -c exit'"
	ic:              "TERM=xterm-256color aws ec2-instance-connect ssh --os-user ubuntu --instance-id"
	j:               "just"
	jd:              "just dev"
	k:               "kubectl"
	ka:              "kubectl apply -f"
	kc:              "kubectl create -f"
	kf:              "\(_env) --chdir ~/thebengeu/qmk_userspace make keyball/keyball44:thebengeu:flash"
	lc:              "supa-admin-cli --config ~/.supa-admin-cli.local"
	lcd:             "cd $(nvim-stdpath data)/lazy"
	lh:              "\(lc) ssh -p"
	lp:              "\(lc) psql --disable-statement-tracking -p"
	m:               "\(_env) --chdir ~/supabase/infrastructure mise"
	mf:              "\(m) fullstack"
	mi:              "\(m) infra"
	mps:             "ssh ubuntu@$(multipass info --format json primary | jq -r .info.primary.ipv4[0])"
	ms:              "\(m) studio"
	n:               "nvim"
	nd:              "npm run dev"
	ni:              "npm install"
	npr:             "nix profile remove"
	nr:              "npm run"
	nrm:             "npm remove"
	os:              #"export COMMAND="$(op signin)"; test -n "$COMMAND" && eval $COMMAND && export OP_TIME=$(date +%s)"#
	p:               "pnpm"
	pc:              "supa-admin-cli"
	pd:              "PULUMI_K8S_DELETE_UNREACHABLE=true pulumi destroy --continue-on-error --remove --skip-preview --stack $(select-supabase-stack)"
	ph:              "supa-admin-cli ssh -p"
	pi:              "pnpm install"
	pid:             "pnpm install --save-dev"
	poi:             "gh poi"
	pp:              "supa-admin-cli psql --disable-statement-tracking -p"
	ppu:             "AWS_PROFILE=supabase pulumi up --stack supabase/prod"
	prc:             "gh pr checkout"
	prd:             "pr --draft"
	prm:             "pnpm remove"
	prune:           "\(dspa); go clean -modcache; pnpm store prune --force; rm -rf ~/.cache/uv ~/.minikube ~/.npm ~/.pulumi/plugins ~/.rustup; rustup default stable"
	prw:             "gh pr view --web"
	psi:             "pulumi stack init"
	psic:            "pulumi stack init --copy-config-from"
	psr:             "pulumi stack rm --force"
	pss:             "pulumi stack select $(select-supabase-stack)"
	pu:              "pulumi up"
	pus:             "pulumi up --skip-preview"
	rc:              "mv ~/supabase/*.worktrees /tmp; ghorg reclone; mv /tmp/*.worktrees ~/supabase"
	rd:              "git rebase-default"
	rgb:             "batgrep"
	rgc:             "cd ~/repos && gc"
	rm:              "trash"
	scc:             #"scc --not-match "package-lock.json|pnpm-lock.yaml""#
	sn:              "eksctl scale nodegroup --cluster $(eks-cluster-name) --name $(nodegroup-name) --nodes"
	sp:              "git -C ~/supabase all pull --quiet"
	sr:              "\(_env) --chdir ~/supabase/infrastructure ./snapshot.sh remove-projects"
	sri:             "\(_env) --chdir ~/supabase/infrastructure ./snapshot.sh restore init"
	ssi:             #"\(_env) --chdir ~/supabase/infrastructure sh -c "./snapshot.sh delete init && ./snapshot.sh save init""#
	ss:              "aws ssm start-session --target"
	st:              "speedtest"
	t:               "pnpm dlx tsx"
	tb:              "time bash -i -c exit"
	tbn:             "time bash --noprofile --norc -i -c exit"
	uc:              "qmk userspace-compile"
	use1:            "export AWS_REGION=us-east-1;"
	use2:            "export AWS_REGION=us-east-2;"
	ui:              "uv tool install"
	uu:              "uv tool uninstall"
	usw1:            "export AWS_REGION=us-west-1;"
	usw2:            "export AWS_REGION=us-west-2;"
	x:               "docker compose exec"

	for suffix, awsProfile in {
		d: "supabase-dev"
		o: "own"
		p: "supabase"
	} {
		"ap\(suffix)": "export AWS_PROFILE=\(awsProfile);"
	}

	for shellAndFlags, noConfigFlag in {
		"fish --interactive": "--no-config"
		"nu --interactive":   "--no-config-file"
		"powershell":         "-NoProfile"
		"pwsh --interactive": "-NoProfile"
		"zsh --interactive":  "--no-rcs"
	} {
		let _shell_prefix = "\(regexp.Find("^[np]?.", shellAndFlags))"

		"h\(_shell_prefix)":  "hyperfine '\(shellAndFlags) -c exit'"
		"h\(_shell_prefix)n": "hyperfine '\(shellAndFlags) \(noConfigFlag) -c exit'"
		"t\(_shell_prefix)":  "time \(shellAndFlags) -c exit"
		"t\(_shell_prefix)n": "time \(shellAndFlags) -\(noConfigFlag) -c exit"
	}

	{
		_non_darwin: {}
		_non_windows: {
			fd:  "fd --hidden"
			rns: #"rm -r "$(nvim-stdpath data)/sessions""#
			tns: "tmux new-session -A -s"
			tm:  "\(tns) 0"
		}
		darwin: _non_windows & {
			bbd: "sh -c 'cd ~/.local/share/chezmoi/ignored && brew bundle dump --file Brewfile --force && git diff Brewfile'"
			bi:  "brew install"
			bic: "brew install --cask"
			bif: "brew info"
			bl:  "brew list"
			bs:  "brew search"
			bu:  "brew uninstall --zap"
			but: "brew untap"
			crv: #"cp ~/Library/Application\ Support/Code/User/keybindings.json ~/.local/share/chezmoi/.chezmoitemplates/code; sed -E "s/(Theme.*\").+(\",)/\1\2/g" ~/Library/Application\ Support/Code/User/settings.json > ~/.local/share/chezmoi/.chezmoitemplates/code/settings.json"#
			cru: #"cp ~/Library/Application\ Support/Cursor/User/keybindings.json ~/.local/share/chezmoi/.chezmoitemplates/code; sed -E "s/(Theme.*\").+(\",)/\1\2/g" ~/Library/Application\ Support/Cursor/User/settings.json > ~/.local/share/chezmoi/.chezmoitemplates/code/settings.json"#
			tg:  "brew update && brew unlink moreutils parallel && brew upgrade moreutils parallel && brew link --overwrite moreutils parallel && genv --chdir ~ PIP_REQUIRE_VIRTUALENV=false topgrade"
			te:  "fd . ~/.Trash --max-depth 1 --exec rm -rf"
			wsk: "wezterm show-keys --lua"
		}
		linux: _non_darwin & _non_windows & {
			aar: "sudo apt autoremove"
			ai:  "sudo apt install"
			ar:  "sudo apt remove"
			ns:  "nix search nixpkgs"
			te:  "trash-empty -f"
			tg:  "PIP_REQUIRE_VIRTUALENV=false topgrade"
		}
		windows: _non_darwin & {
			chi: "sudo choco install"
			chu: "sudo choco uninstall"
			crv: #"cp ~/AppData/Roaming/Code/User/keybindings.json ~/.local/share/chezmoi/.chezmoitemplates/code; sed -E 's/(Theme.*").+(",)/\1\2/g' ~/AppData/Roaming/Code/User/settings.json > ~/.local/share/chezmoi/.chezmoitemplates/code/settings.json"#
			dpw: #"powershell -c "Invoke-Expression (\"pwsh \" + (New-Object -ComObject WScript.Shell).CreateShortcut(\"\$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk\").Arguments.Replace('\"\"\"', \"'\"))""#
			fd:  "\(_non_windows.fd) --path-separator '//'"
			rns: #"rm -r "$(nvim-stdpath data)\sessions""#
			tg:  "scoop update topgrade; winget upgrade spotify; spicetify update; PIP_REQUIRE_VIRTUALENV=false sudo topgrade"
			wi:  "winget install"
			ws:  "winget search"
			wsk: "wezterm show-keys --lua"
			wu:  "winget uninstall"
		}
	}[_os]

	v:        string | *"neovide"
	_neovide: string | *"neovide -- --cmd"

	if _os == "darwin" {
		_neovide: "open -b com.neovide.neovide --args -- --cmd"
		v:        "\(_neovide) \"cd $PWD\""
	}

	if strings.HasSuffix(_hostname, "-wsl") {
		v:        "/mnt/c/Users/beng/scoop/shims/neovide.exe --wsl"
		_neovide: "\(v) -- --cmd"
	}

	csv: "\(_neovide) 'cd ~/thebengeu/cheatsheet' ~/thebengeu/cheatsheet/README.md"

	_gitAliasDirectories: {
		a: "$HOME/supabase/supabase-admin-api"
		c: "$HOME/.local/share/chezmoi"
		e: "$HOME/supabase/data-engineering"
		f: "$HOME/thebengeu/qmk_firmware"
		h: "$HOME/supabase/helper-scripts"
		i: "$HOME/supabase/infrastructure"
		k: "$HOME/thebengeu/drakon"
		p: "$HOME/supabase/postgres"
		u: "$HOME/thebengeu/qmk_userspace"
		w: "$HOME/supabase/supabase"
		z: "$HOME/thebengeu/zmk-config"
	}
	_nvimAliasDirectories: _gitAliasDirectories & {
		b: "$HOME/sb"
	}
	_rgAliasDirectories: _nvimAliasDirectories & {
		s: "$HOME/supabase"
	}
	_aliasDirectories: _rgAliasDirectories & {
		d: "$HOME/Downloads"
		g: "$HOME/thebengeu"
		m: "$HOME/supabase/helper-scripts/modern-scripts"
		r: "$HOME/repos"
		t: "$HOME/temp"
	}

	for prefix, directory in _aliasDirectories {
		"\(prefix)cd": "cd \(directory)"
	}

	for prefix, directory in _rgAliasDirectories {
		"\(prefix)rg": "\(_env) --chdir \(strings.Replace(directory, "$HOME", "~", -1)) rg"
	}

	_gitAliases: {
		aa:  "add -A"
		b:   "branch --show-current"
		ca:  "commit --amend"
		cam: "commit -a -m"
		cm:  "commit -m"
		d:   "diff"
		l:   "lg"
		lm:  "log-markdown"
		lmr: "lmr"
		lp:  "log --ext-diff --patch"
		p:   "pull"
		P:   "push"
		pf:  "pf"
		pf:  "pf"
		pu:  "pu"
		r:   "rebase"
		rc:  "rebase --continue"
		rh:  "reset --hard HEAD"
		rru: "remote remove upstream"
		rv:  "remote -v"
		s:   "s"
		sa:  "stash apply"
		sp:  "stash pop"
		sP:  "stash push"
		sw:  "sw"
		w:   "wip"
		wa:  "worktree add"
		wr:  "worktree remove"
	}

	for gitAlias, command in _gitAliases {
		"g\(gitAlias)": "git \(command)"
	}
	for prefix, directory in _gitAliasDirectories {
		"\(prefix)g":   "git -C \(directory)"
		"\(prefix)lg":  "lg --path \(directory)"
		"\(prefix)pr":  "cd \(directory); pr"
		"\(prefix)prd": "cd \(directory); \(prd)"
	}
	for prefix, directory in _nvimAliasDirectories {
		"\(prefix)n": "nvim --cmd 'cd \(strings.Replace(directory, "$HOME", "~", -1))'"
	}

	for shAlias, command in {
		jsr: #"printf "\e[6 q"; node"#
		tsr: #"printf "\e[6 q"; pnpm dlx tsx"#
	} {
		"\(shAlias)": "sh -c '\(command)'"
	}

	for appName in _nvimConfigs {
		"\(appName)": "NVIM_APPNAME=\(appName) nvim"
	}
}
environmentVariables: {
	BAT_THEME:                     "Catppuccin-mocha"
	DOCKER_CLI_HINTS:              false
	EDITOR:                        "nvim"
	EJSON_KEYDIR:                  "$HOME/.config/ejson/keys"
	EZA_ICON_SPACING:              1
	FZF_DEFAULT_OPTS:              "--color=spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#45475a"
	GH_USERNAME:                   "thebengeu"
	GITLINT_CONFIG:                "$HOME/.config/gitlint/gitlint.ini"
	HOMEBREW_CLEANUP_MAX_AGE_DAYS: 0
	LESS:                          "--quit-if-one-screen --RAW-CONTROL-CHARS"
	MANPAGER:                      "nvim +Man!"
	MICRO_TRUECOLOR:               1
	PIP_REQUIRE_VIRTUALENV:        true
	PULUMI_SKIP_UPDATE_CHECK:      true
	RIPGREP_CONFIG_PATH:           "$HOME/.config/ripgrep/config"
	USQL_SHOW_HOST_INFORMATION:    false

	{
		_common: {
			HOMEBREW_NO_AUTO_UPDATE: 1
			LG_CONFIG_FILE:          "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/mocha-lavender.yml"
			PNPM_HOME:               "$HOME/.local/share/pnpm"
		}
		darwin: _common
		linux: _common & {
			AWS_VAULT_BACKEND: "pass"
			FLYCTL_INSTALL:    "$HOME/.fly"
		}
		windows: {
			LG_CONFIG_FILE:   "$APPDATA\\\\lazygit\\\\config.yml,$APPDATA\\\\lazygit\\\\mocha-lavender.yml"
			NODE_NO_WARNINGS: 1
			PNPM_HOME:        "$HOME/AppData/Local/pnpm"
		}
	}[_os]
}
functions: {
	gc: {
		lines: [
			#"git clone --recurse-submodules "$repo""#,
			#"cd "$(echo "$repo" | sed s/\.git\$// | grep -oE '([^:/]+)$')""#,
			"glow README.md",
		]
		parameters: ["repo"]
	}
	md: {
		lines: [
			"mkdir -p \"$directory\"",
			"cd \"$directory\"",
		]
		parameters: ["directory"]
	}
}
_wsl_paths: [...string]
if strings.HasSuffix(_hostname, "-wsl") {
	_wsl_paths: [
		"/mnt/c/Program\\ Files/Neovide",
		"/mnt/c/Program\\ Files\\ \\(x86\\)/nvim/bin",
		"/mnt/c/Users/beng/AppData/Local/Microsoft/WinGet/Links",
	]
}
paths: list.Concat([{
	darwin: [
		"~/Library/Python/3.11/bin",
		"~/Library/Python/3.12/bin",
		"/opt/homebrew/opt/curl/bin",
		"/usr/local/bin",
	]
	linux: list.Concat([_wsl_paths, [
		"~/.temporalio/bin",
		"$FLYCTL_INSTALL/bin",
	]])
	windows: [
		"~/AppData/Roaming/Python/Python313/Scripts",
		"/usr/bin",
	]
}[_os], [
	"$PNPM_HOME",
	"~/.cargo/bin",
	"~/.config/emacs/bin",
	"~/.krew/bin",
	"~/.local/bin",
	"~/go/bin",
	"~/repos/git-fuzzy/bin",
	"~/supabase/supa-admin-cli/bin",
	"~/thebengeu/scripts",
]])
