function __wezterm_set_user_var --argument-names name value
    set --function set_user_var "\033]1337;SetUserVar=$name=$(echo -n "$value" | base64)\007"

    if test -n "$TMUX"
        echo -en "\033Ptmux;\033$set_user_var\033\\"
    else
        echo -en $set_user_var
    end
end
