New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\chezmoi\chezmoi.toml" -Target "$env:USERPROFILE\.local\share\chezmoi\chezmoi.toml"

$manifestPaths = @(
  'a\AudioBand\AudioBand\1.2.1'
  'r\Rabby\RabbyDesktop\0.31.0'
  't\Todoist\Todoist\8.5.0'
)

foreach ($manifestPath in $manifestPaths) {
  winget install --silent --manifest "$env:USERPROFILE\powershell\manifests\$manifestPath"
}

$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + [System.Environment]::GetEnvironmentVariable("PATH", "User")
