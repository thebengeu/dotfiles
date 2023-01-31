eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/doomemacs/bin
fish_add_path ~/go/bin
if status is-interactive
    set --export --global EDITOR nvim
    set --global fish_greeting
    fnm env --use-on-cd | source
    mcfly init fish | source
    zoxide init --cmd cd fish | source
    abbr --add b bat
    abbr --add bi 'brew install'
    abbr --add bui 'brew uninstall'
    abbr --add ca 'chezmoi apply'
    abbr --add cgca 'chezmoi git -- commit --amend'
    abbr --add cgcam 'chezmoi git -- commit -a -m'
    abbr --add cgd 'chezmoi git diff'
    abbr --add cgp 'chezmoi git push'
    abbr --add cgpr 'chezmoi git -- pull --rebase'
    abbr --add cgs 'chezmoi git status'
    abbr --add cgss 'chezmoi git -- status -s'
    abbr --add cr 'chezmoi re-add'
    abbr --add cat bat
    abbr --add e 'emacsclient -nw'
    abbr --add g git
    abbr --add gaa 'git add -A'
    abbr --add gca 'git commit --amend'
    abbr --add gcam 'git commit -a -m'
    abbr --add gcm 'git commit -m'
    abbr --add gco 'git checkout'
    abbr --add gd 'git diff'
    abbr --add gl 'git log'
    abbr --add gp 'git push'
    abbr --add gpr 'git pull --rebase'
    abbr --add grbc 'git rebase --continue'
    abbr --add gs 'git status'
    abbr --add gss 'git status -s'
    abbr --add lg 'lazygit'
    abbr --add ll 'exa --git --icons --long'
    abbr --add ls 'exa --icons'
    abbr --add n nvim
    abbr --add pr 'gh pr create -f'
    abbr --add prr 'gh pr create -f -r'
    abbr --add vim nvim
    function br --wraps=broot
        set -l cmd_file (mktemp)
        if broot --outcmd $cmd_file $argv
            read --local --null cmd < $cmd_file
            rm -f $cmd_file
            eval $cmd
        else
            set -l code $status
            rm -f $cmd_file
            return $code
        end
    end
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
