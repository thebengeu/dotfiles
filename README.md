# Setup

## Darwin

```console
curl -s 'https://raw.githubusercontent.com/thebengeu/dotfiles/master/.chezmoiscripts/darwin/run_onchange_init.sh' >/tmp/run_onchange_init.sh
sh /tmp/run_onchange_init.sh
rm /tmp/run_onchange_init.sh
```

- Install [Amphetamine Power Protect](https://x74353.github.io/Amphetamine-Power-Protect/)
- Install [Homerow](https://install.appcenter.ms/users/dexterleng/apps/homerow-redux/distribution_groups/production)
- Install [Open In native client](https://github.com/andy-portmen/native-client/releases)

## Linux

```console
useradd --create-home --groups sudo --shell /bin/bash beng
passwd beng
curl -s 'https://github.com/thebengeu/dotfiles/raw/master/.chezmoiscripts/linux/run_onchange_init.sh' > /tmp/run_onchange_init.sh
bash /tmp/run_onchange_init.sh
rm /tmp/run_onchange_init.sh
```

## Windows

- Update Microsoft Store apps
- Install [Aptakube](https://aptakube.com/)
- Install [ManicTime Server](https://www.manictime.com/download/server)
- Install [Rabby Desktop](https://rabby.io/?platform=desktop)

```powershell
Set-ExecutionPolicy Unrestricted
irm https://github.com/thebengeu/dotfiles/raw/master/.chezmoiscripts/windows/run_onchange_init-admin.ps1 | iex
```

## Common

```console
fish_config theme save 'Catppuccin Mocha'
```
