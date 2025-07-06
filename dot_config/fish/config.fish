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

if test -z "$WEZTERM_CONFIG_DIR" -a -n "$WEZTERM_UNIX_SOCKET"
    set --export SSH_CONNECTION '127.0.0.1 22 127.0.0.1 22'
end

set --export WSL_HOSTNAME_PREFIX $(string match --groups-only --regex '(.*)-wsl$' $(prompt_hostname))

if test -n "$WSL_HOSTNAME_PREFIX" -a \( -z "$USERDOMAIN" -o "$WSL_HOSTNAME_PREFIX" = "$(string lower $USERDOMAIN | sed s/\r//)" \)
    set --export TITLE_PREFIX wsl:
else if test -n "$SSH_CONNECTION"
    set --export TITLE_PREFIX $(prompt_hostname):
end

function fish_title
    if test -n "$WEZTERM_UNIX_SOCKET" -a -n "$WSL_HOSTNAME_PREFIX"
        if test "$WSL_HOSTNAME_PREFIX" = "$(wezterm cli list-clients --format json | jq -r 'min_by(.idle_time.secs + .idle_time.nanos / 1e9).hostname')"
            set --export TITLE_PREFIX wsl:
        else
            set --export TITLE_PREFIX $(prompt_hostname):
        end
    end

    set --function current_command (status current-command)

    if test "$current_command" != fish
        set --function title "$current_command"
    else
        set --function title "$(prompt_pwd --dir-length=0)"
    end

    if test -n "$TMUX"
        tmux rename-window -t $(tmux display-message -p '#{window_index}') $title
    end

    echo "$TITLE_PREFIX$title"
end

function fish_hybrid_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
    bind \cj true
    bind \ck true
    bind \cl true
end

if test "$TERM_PROGRAM" != WarpTerminal
    set --global fish_key_bindings fish_hybrid_key_bindings
end

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

function __wezterm_user_vars_fish_prompt --on-event fish_prompt
    __wezterm_set_user_var PROMPT_TIME $(date +%s)
    __wezterm_set_user_var WEZTERM_HOSTNAME $(hostname)
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

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Override autopair.fish binding.
function _fifc_fish_key_bindings --on-variable fish_key_bindings
    for mode in default insert
        bind --mode $mode \t _fifc
    end
end

_fifc_fish_key_bindings

function kubectl --wraps kubectl
    command kubecolor $argv
end
