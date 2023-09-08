#!/bin/fish
status is-interactive || exit

function __on_fish_prompt --on-event fish_prompt
    functions --erase __on_fish_prompt

    function __update_cwd_osc --on-variable PWD
        printf "\e]7;file://$hostname$(cygpath --mixed $PWD)\a"
    end

    __update_cwd_osc
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
