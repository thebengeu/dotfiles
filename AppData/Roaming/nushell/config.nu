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
    shell_integration: true
    show_banner: false
    table: {
        index_mode: auto
    }
}

source ~/.local/share/atuin/init.nu
use ~/.cache/starship/init.nu
source ~/.zoxide.nu
