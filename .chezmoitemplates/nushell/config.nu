let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell $spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)
    let spans = (if $expanded_alias != null  {
        $spans | skip 1 | prepend ($expanded_alias | split words)
    } else { $spans })

    {
        git: $fish_completer
        nu: $fish_completer
        z: $zoxide_completer
        zi: $zoxide_completer
    } | get -i $spans.0 | default $carapace_completer | do $in $spans

}

$env.config = {
    completions: {
        external: {
            completer: $external_completer
            enable: true
        }
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

alias nu-open = open
alias open = ^open

source generated.nu
