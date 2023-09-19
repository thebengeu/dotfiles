#!/usr/bin/env sh
export config_dir="$1"
export sub_dir="$2"
export path_suffix="$3"
export base_dir="$config_dir$sub_dir"

# shellcheck disable=SC2016
fd --base-directory "$base_dir" --fixed-strings --full-path --path-separator '//' --strip-cwd-prefix --type file "$base_dir$path_suffix" --exec sh -c 'cd "$(chezmoi source-path)/.chezmoitemplates"; mkdir -p {//}; cp "$base_dir/{}" {}; content="{{- template \"{}\" -}}"; for dir in ../AppData/Roaming ../dot_config; do mkdir -p "$dir/$sub_dir/{//}"; echo "$content" >"$dir/$sub_dir/{}"; done'
