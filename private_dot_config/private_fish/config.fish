fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.pulumi/bin
fish_add_path ~/.temporalio/bin
fish_add_path ~/.yarn/bin
fish_add_path ~/go/bin
if status is-interactive
    set --export BAT_PAGER 'less --mouse --quit-if-one-screen --RAW-CONTROL-CHARS'
    set --export EDITOR nvim
    set --export MCFLY_DELETE_WITHOUT_CONFIRM TRUE
    set --export MCFLY_DISABLE_MENU TRUE
    set --export MCFLY_KEY_SCHEME vim
    set --export NODE_NO_WARNINGS 1
    set --global fish_cursor_default block
    set --global fish_cursor_insert line
    set --global fish_cursor_replace_one underscore
    set --global fish_greeting
    set --global fish_vi_force_cursor 1
    mcfly init fish | source
    zoxide init --cmd cd fish | source
    abbr --add agca 'git -C ~/ansible commit --amend'
    abbr --add agcam 'git -C ~/ansible commit -a -m'
    abbr --add agd 'git -C ~/ansible diff'
    abbr --add agl 'git -C ~/ansible lg'
    abbr --add aglp 'git -C ~/ansible lg --patch'
    abbr --add agP 'git -C ~/ansible push'
    abbr --add agp 'git -C ~/ansible pull'
    abbr --add ags 'git -C ~/ansible s'
    abbr --add alg 'lazygit --path ~/ansible'
    abbr --add an 'nvim --cmd "cd ~/ansible"'
    abbr --add b bat
    abbr --add bi 'brew install'
    abbr --add bui 'brew uninstall'
    abbr --add ca 'chezmoi apply --exclude templates'
    abbr --add cat bat
    abbr --add cgca 'chezmoi git -- commit --amend'
    abbr --add cgcam 'chezmoi git -- commit -a -m'
    abbr --add cgd 'chezmoi git diff'
    abbr --add cgl 'chezmoi git lg'
    abbr --add cglp 'chezmoi git -- lg --patch'
    abbr --add cgP 'chezmoi git push'
    abbr --add cgp 'chezmoi git pull'
    abbr --add cgpa 'chezmoi git pull && chezmoi apply --exclude templates'
    abbr --add cgs 'chezmoi git s'
    abbr --add clg 'lazygit --path ~/.local/share/chezmoi'
    abbr --add cn 'nvim --cmd "cd ~/.local/share/chezmoi"'
    abbr --add cr 'chezmoi re-add'
    abbr --add cu 'chezmoi update --exclude templates'
    abbr --add e 'emacsclient -nw'
    abbr --add g git
    abbr --add gaa 'git add -A'
    abbr --add gc 'git clone'
    abbr --add gca 'git commit --amend'
    abbr --add gcam 'git commit -a -m'
    abbr --add gcm 'git commit -m'
    abbr --add gco 'git checkout'
    abbr --add gd 'git diff'
    abbr --add gl 'git lg'
    abbr --add glp 'git lg --patch'
    abbr --add gP 'git push'
    abbr --add gp 'git pull'
    abbr --add gr 'git rebase'
    abbr --add grbc 'git rebase --continue'
    abbr --add grhh 'git reset --hard HEAD'
    abbr --add gs 'git s'
    abbr --add gsa 'git stash apply'
    abbr --add gsP 'git stash push'
    abbr --add gsp 'git stash pop'
    abbr --add j just
    abbr --add lg lazygit
    abbr --add ll 'exa --git --icons --long'
    abbr --add ls 'exa --icons'
    abbr --add n nvim
    abbr --add nr 'sh -c "printf \"\e[6 q\"; node"'
    abbr --add os 'set COMMAND $(op signin) && test -n "$COMMAND" && eval $COMMAND && set --export OP_TIME $(date +%s)'
    abbr --add pd 'pnpm dev'
    abbr --add pi 'pnpm i'
    abbr --add pp 'psql postgresql://postgres:postgres@localhost:5432/postgres'
    abbr --add ppg 'pnpm prisma generate'
    abbr --add pr 'gh pr create -f'
    abbr --add prm 'pnpm rm'
    abbr --add prr 'gh pr create -f -r'
    abbr --add rg 'rg --max-columns 1000'
    abbr --add scc 'scc --not-match "package-lock.json|pnpm-lock.yaml"'
    abbr --add tg topgrade
    abbr --add tns 'tmux new-session -A -s'
    abbr --add tsx 'pnpm tsx'
    abbr --add tsxr 'sh -c \'printf "\e[6 q"; pnpm tsx\''
    abbr --add vim nvim
    alias rm safe-rm
    function fish_title
        if test -n "$TMUX"
            tmux rename-window -t $(tmux display-message -p '#{window_index}') $PWD
        end
        pwd
    end
    function fish_hybrid_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
    end
    set --global fish_key_bindings fish_hybrid_key_bindings
end
