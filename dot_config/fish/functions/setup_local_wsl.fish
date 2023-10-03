function setup_local_wsl --no-scope-shadowing
    set --export TITLE_PREFIX wsl:
    fish_add_path --global "/mnt/c/Users/$USER/scoop/shims"
end
