# Setup

## Darwin

```console
curl -s 'https://raw.githubusercontent.com/thebengeu/dotfiles/master/.chezmoiscripts/darwin/run_onchange_init.sh' >/tmp/run_onchange_init.sh
sh /tmp/run_onchange_init.sh
rm /tmp/run_onchange_init.sh
defaults import com.sindresorhus.Velja com.sindresorhus.Velja.plist
```

- Install [Amphetamine Power Protect](https://x74353.github.io/Amphetamine-Power-Protect/)
- Install [Homerow](https://install.appcenter.ms/users/dexterleng/apps/homerow-redux/distribution_groups/production)
- Install [Immersed Desktop Agent](https://immersed.com/)
- Install [Meta Quest Remote Desktop](https://www.meta.com/help/quest/articles/horizon/getting-started-in-horizon-workrooms/use-computer-in-VR-workrooms/)
- Install [Open In native client](https://github.com/andy-portmen/native-client/releases)

## Linux

```console
curl -s 'https://github.com/thebengeu/dotfiles/raw/master/.chezmoiscripts/linux/run_onchange_init.sh' | bash
```

## Windows

- Update Microsoft Store apps

```powershell
Set-ExecutionPolicy Unrestricted
irm https://github.com/thebengeu/dotfiles/raw/master/.chezmoiscripts/windows/run_onchange_init-admin.ps1 | iex
```

## Common

```console
fish_config theme save 'Catppuccin Mocha'
```
