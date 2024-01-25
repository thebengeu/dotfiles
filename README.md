# Setup

## Darwin

```console
curl -s 'https://raw.githubusercontent.com/thebengeu/dotfiles/master/.chezmoiscripts/darwin/run_onchange_init.sh' >/tmp/run_onchange_init.sh
sh /tmp/run_onchange_init.sh
rm /tmp/run_onchange_init.sh
defaults import com.sindresorhus.Velja com.sindresorhus.Velja.plist
```

- Install [Homerow](https://install.appcenter.ms/users/dexterleng/apps/homerow-redux/distribution_groups/production)
- Install [Vanta Agent](https://app.vanta.com/employee/onboarding)

## Linux

```console
curl -s 'https://github.com/thebengeu/dotfiles/raw/master/.chezmoiscripts/linux/run_onchange_init.sh' | sh
```

## Windows

```powershell
irm https://github.com/thebengeu/dotfiles/raw/master/.chezmoiscripts/windows/run_onchange_init-admin.ps1 | iex
```

## Common

```console
fish_config theme save 'Catppuccin Mocha'
```
