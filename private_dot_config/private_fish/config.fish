eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin
if status is-interactive
    set --export --global EDITOR nvim
    fnm env --use-on-cd | source
    mcfly init fish | source
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
    abbr --add gpom 'git push origin master'
    abbr --add grbc 'git rebase --continue'
    abbr --add gs 'git status'
    abbr --add gss 'git status -s'
    abbr --add ll 'EXA_ICON_SPACING=2 exa --git --icons --long'
    abbr --add ls 'EXA_ICON_SPACING=2 exa --icons'
    abbr --add pr 'gh pr create -f'
    abbr --add prr 'gh pr create -f -r'
    abbr --add vim nvim
    function fish_title
        if test -n "$TMUX"
            tmux rename-window -t $(tmux display-message -p '#{window_index}') $PWD
        end
        pwd
    end
    function fish_user_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
    end
end
