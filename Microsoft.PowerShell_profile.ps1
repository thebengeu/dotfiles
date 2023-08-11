Invoke-Expression (&starship init powershell)
Invoke-Expression (& {
 (zoxide init --cmd cd powershell | Out-String) }
)

Import-Module PSFzf
Import-Module PSWindowsUpdate

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-Alias b bat
Set-Alias cat bat
Set-Alias g git
Set-Alias j just
Set-Alias lg lazygit
Set-Alias n nvim
Set-Alias p pnpm
Set-Alias tg topgrade
Set-Alias vim nvim
Set-Alias which Get-Command

$Env:NODE_NO_WARNINGS = 1
$Env:PNPM_HOME = "$env:LOCALAPPDATA\pnpm"
$Env:Path += @(
  "$Env:ProgramFiles\PostgreSQL\15\bin"
  $Env:PNPM_HOME
  "$Env:USERPROFILE\go\bin"
) -join [IO.Path]::PathSeparator

function ca
{
  chezmoi apply --exclude templates
}

function cgca
{
  chezmoi git -- commit --amend
}

function cgcam
{
  chezmoi git -- commit -a -m $args
}

function cgd
{
  chezmoi git diff
}

function cgl
{
  chezmoi git lg
}

function cglp
{
  chezmoi git -- lg --patch
}

function cgP
{
  chezmoi git push
}

function cgp
{
  chezmoi git pull
}

function cgs
{
  chezmoi git s
}

function clg
{
  lazygit --path $Env:USERPROFILE/.local/share/chezmoi
}

function cn
{
  nvim --cmd "cd ~/.local/share/chezmoi"
}

function cr
{
  chezmoi re-add
}

function cu
{
  chezmoi update --exclude templates
}

function gaa
{
  git add -A
}

function gca
{
  git commit --amend
}

function gcam
{
  git commit -a -m $args
}

function gcm
{
  git commit -m $args
}

function gco
{
  git checkout $args
}

function gd
{
  git diff
}

function gl
{
  git lg
}

function glp
{
  git lg --patch
}

function gP
{
  git push
}

function gp
{
  git pull
}

function gr
{
  git rebase
}

function grbc
{
  git rebase --continue
}

function grhh
{
  git reset --hard HEAD
}

function gs
{
  git s
}

function gsa
{
  git stash apply
}

function gsP
{
  git stash push
}

function gsp
{
  git stash pop
}

function jd
{
  just dev
}

function pd
{
  pnpm dev
}

function pgca
{
  git -C $Env:USERPROFILE/powershell commit --amend
}

function pgcam
{
  git -C $Env:USERPROFILE/powershell commit -a -m $args
}

function pgd
{
  git -C $Env:USERPROFILE/powershell diff
}

function pgl
{
  git -C $Env:USERPROFILE/powershell lg
}

function pglp
{
  git -C $Env:USERPROFILE/powershell lg --patch
}

function pgP
{
  git -C $Env:USERPROFILE/powershell push
}

function pgp
{
  git -C $Env:USERPROFILE/powershell pull
}

function pgs
{
  git -C $Env:USERPROFILE/powershell s
}

function pi
{
  pnpm i $args
}

function plg
{
  lazygit --path $Env:USERPROFILE/powershell
}

function pn
{
  nvim --cmd "cd ~/powershell"
}

function pp
{
  psql postgresql://postgres:postgres@localhost:5432/postgres
}

function ppg
{
  pnpm prisma generate
}

function prm
{
  pnpm rm $args
}

function rg
{
  & $(Get-Command -CommandType Application rg) --max-columns 1000 $args
}

function scc
{
  & $(Get-Command -CommandType Application scc) --not-match "package-lock.json|pnpm-lock.yaml" $args
}

function tsx
{
  pnpm tsx $args
}
