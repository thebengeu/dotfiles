$env.config = {
    cd: {
        abbreviations: true
    }
    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }
    edit_mode: vi
    keybindings: []
    show_banner: false
    table: {
        index_mode: auto
    }
}

source aliases.nu
source ~/.local/share/atuin/init.nu
source ~/.zoxide.nu

use ~/.cache/starship/init.nu
