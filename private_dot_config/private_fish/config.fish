eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path ~/.cargo/bin
fish_add_path ~/go/bin
if status is-interactive
  mcfly init fish | source
  starship init fish | source
  zoxide init --cmd cd fish | source
end
