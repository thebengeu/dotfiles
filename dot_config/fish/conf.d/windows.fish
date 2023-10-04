status is-interactive || exit

chcp.com 1252 >/dev/null

function __on_fish_prompt --on-event fish_prompt
    functions --erase __on_fish_prompt

    function __update_cwd_osc --on-variable PWD
        printf "\e]7;file://$hostname$(cygpath --mixed $PWD)\a"
    end

    __update_cwd_osc
end
