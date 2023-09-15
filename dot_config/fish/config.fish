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

if test -f /proc/sys/fs/binfmt_misc/WSLInterop
    set --export TITLE_PREFIX wsl
end

if set -q SSH_TTY
    set --export TITLE_PREFIX $(prompt_hostname)
end

function fish_title
    set --local full_prompt_pwd $(prompt_pwd --dir-length=0)

    if test -n "$TMUX"
        tmux rename-window -t $(tmux display-message -p '#{window_index}') $full_prompt_pwd
    end

    if set -q TITLE_PREFIX
        echo "$TITLE_PREFIX:$full_prompt_pwd"
    else
        echo $full_prompt_pwd
    end
end

function fish_hybrid_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

set --global fish_key_bindings fish_hybrid_key_bindings

function __mark_prompt_start --on-event fish_prompt --on-event fish_cancel --on-event fish_posterror
    test "$__prompt_state" != prompt-start
    and echo -en "\e]133;D\a"
    set --global __prompt_state prompt-start
    echo -en "\e]133;A\a"
end
__mark_prompt_start

function __mark_output_start --on-event fish_preexec
    set --global __prompt_state pre-exec
    echo -en "\e]133;C\a"
end

function __mark_output_end --on-event fish_postexec
    set --global __prompt_state post-exec
    echo -en "\e]133;D;$status\a"
end

function __wezterm_set_user_var --argument-names name value
    if test -n "$TMUX"
        printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "$name" $(echo -n "$value" | base64)
    else
        printf "\033]1337;SetUserVar=%s=%s\007" "$name" $(echo -n "$value" | base64)
    end
end

function __wezterm_user_vars_fish_prompt --on-event fish_prompt
    __wezterm_set_user_var WEZTERM_PROG ""

    if test -n "$TMUX"
        __wezterm_set_user_var WEZTERM_IN_TMUX 1
    else
        __wezterm_set_user_var WEZTERM_IN_TMUX 0
    end
end


function __wezterm_user_vars_preexec --on-event fish_preexec
    __wezterm_set_user_var WEZTERM_PROG "$argv[1]"
end
