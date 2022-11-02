eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin
if status is-interactive
  mcfly init fish | source
  starship init fish | source
  zoxide init --cmd cd fish | source
  abbr --add bi 'brew install'
  abbr --add bui 'brew uninstall'
  abbr --add cat bat
  abbr --add e 'COLORTERM=truecolor emacs -nw'
  abbr --add g git
  abbr --add gaa 'git add -A'
  abbr --add gcam 'git commit -a -m'
  abbr --add gcm 'git commit -m'
  abbr --add gco 'git checkout'
  abbr --add gp 'git pull'
  abbr --add grbc 'git rebase --continue'
  abbr --add gs 'git status'
  abbr --add gss 'git status -s'
  abbr --add ll 'EXA_ICON_SPACING=2 exa --git --icons --long'
  abbr --add ls 'EXA_ICON_SPACING=2 exa --icons'
  abbr --add pr 'gh pr create -f'
  abbr --add prr 'gh pr create -f -r'
  abbr --add vim nvim
end
