New-Item -ItemType SymbolicLink -Path "$Env:USERPROFILE\.config\chezmoi\chezmoi.toml" -Target "$Env:USERPROFILE\.local\share\chezmoi\chezmoi.toml"

$manifestPaths = @(
  'a\AudioBand\AudioBand\1.2.1'
  'r\Rabby\RabbyDesktop\0.31.0'
  't\Todoist\Todoist\8.5.0'
)

foreach ($manifestPath in $manifestPaths)
{
  winget install --manifest "$Env:USERPROFILE\powershell\manifests\$manifestPath" --silent
}
