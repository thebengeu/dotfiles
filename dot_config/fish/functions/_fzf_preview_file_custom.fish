function _fzf_preview_file_custom
    set -f file_path $argv

    if test -L "$file_path" # symlink
        set -l target_path (realpath "$file_path")

        set_color yellow
        echo "'$file_path' is a symlink to '$target_path'."
        set_color normal

        _fzf_preview_file_custom "$target_path"
    else if test -f "$file_path" # regular file
        bat --color always --style plain "$file_path"
    else if test -d "$file_path" # directory
        command lsd --color always --icon always "$file_path"
    else if test -c "$file_path"
        _fzf_report_file_type "$file_path" "character device file"
    else if test -b "$file_path"
        _fzf_report_file_type "$file_path" "block device file"
    else if test -S "$file_path"
        _fzf_report_file_type "$file_path" socket
    else if test -p "$file_path"
        _fzf_report_file_type "$file_path" "named pipe"
    else
        echo "$file_path doesn't exist." >&2
    end
end
