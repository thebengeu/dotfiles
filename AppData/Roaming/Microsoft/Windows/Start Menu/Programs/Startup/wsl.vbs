Set Shell = CreateObject("WScript.Shell")
Shell.Run "wsl --exec 'tmux has-session -t 0 2>/dev/null || tmux new-session -d -s 0'", 0
