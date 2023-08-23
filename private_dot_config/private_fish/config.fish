status is-interactive || exit

set --global fish_cursor_default block
set --global fish_cursor_insert line
set --global fish_cursor_replace_one underscore
set --global fish_greeting
set --global fish_vi_force_cursor 1


enable_transience

abbr --add man batman
abbr --add os 'set COMMAND $(op signin) && test -n "$COMMAND" && eval $COMMAND && set --export OP_TIME $(date +%s)'

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
