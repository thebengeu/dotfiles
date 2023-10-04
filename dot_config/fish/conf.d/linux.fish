if test "$TERM_PROGRAM" = WezTerm
    set --export TERM wezterm
end

set --global --append fish_complete_path /usr/share/fish/completions/completions
