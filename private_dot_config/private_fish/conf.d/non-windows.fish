set --export PNPM_HOME ~/.local/share/pnpm

fish_add_path --global $PNPM_HOME
fish_add_path --global ~/.cargo/bin
fish_add_path --global ~/.local/bin
fish_add_path --global ~/.pulumi/bin
fish_add_path --global ~/.temporalio/bin
fish_add_path --global ~/go/bin

status is-interactive || exit

set --export MCFLY_DELETE_WITHOUT_CONFIRM TRUE
set --export MCFLY_DISABLE_MENU TRUE
set --export MCFLY_KEY_SCHEME vim
set --export NODE_NO_WARNINGS 1

mcfly init fish | source

abbr --add ll 'exa --git --icons --long'
abbr --add ls 'exa --icons'

alias rm safe-rm
