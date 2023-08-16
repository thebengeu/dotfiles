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
}

source ~/.local/share/atuin/init.nu
use ~/.cache/starship/init.nu
source ~/.zoxide.nu
