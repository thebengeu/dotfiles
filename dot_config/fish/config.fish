status is-interactive || exit

set --global fish_cursor_default block
set --global fish_cursor_insert line
set --global fish_cursor_replace_one underscore
set --global fish_greeting
set --global fish_vi_force_cursor 1
set --global fzf_diff_highlighter delta --paging never
set --global fzf_directory_opts --preview '_fzf_preview_file_custom {}'
set --global fzf_git_log_format '%C(bold blue)%h%Creset %s'
set --global sponge_purge_only_on_exit true

abbr --add man batman
abbr --add os 'set COMMAND $(op signin) && test -n "$COMMAND" && eval $COMMAND && set --export OP_TIME $(date +%s)'

function fish_title
    set --local full_prompt_pwd (prompt_pwd --dir-length=0)

    if test -n "$TMUX"
        tmux rename-window -t $(tmux display-message -p '#{window_index}') $full_prompt_pwd
    end

    echo $full_prompt_pwd
end

function fish_hybrid_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

set --global fish_key_bindings fish_hybrid_key_bindings

function __wezterm_set_user_var --argument-names name value
    if [ -z "$TMUX" ]
        printf "\033]1337;SetUserVar=%s=%s\007" "$name" $(echo -n "$value" | base64)
    else
        printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "$name" $(echo -n "$value" | base64)
    end
end
