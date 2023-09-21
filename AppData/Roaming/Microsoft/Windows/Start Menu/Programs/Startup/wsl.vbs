CreateObject("WScript.Shell").Run "wsl --exec sh -c ""tmux has-session -t 0 2>/dev/null || tmux new-session -d -s 0""", 0
