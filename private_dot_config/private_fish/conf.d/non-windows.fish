status is-interactive || exit

set --export MCFLY_DELETE_WITHOUT_CONFIRM TRUE
set --export MCFLY_DISABLE_MENU TRUE
set --export MCFLY_KEY_SCHEME vim

mcfly init fish | source

abbr --add ls 'exa --icons'
abbr --add lsl 'exa --git --icons --long'

alias rm safe-rm
