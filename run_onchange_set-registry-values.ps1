function Set-Registry-Values($path, $values)
{
  foreach ($name in $values.Keys)
  {
    Set-ItemProperty $path $name $values[$name]
  }
}

$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

Set-Registry-Values 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' @{
  Hidden          = 1
  HideFileExt     = 0
  ShowSuperHidden = 1
  ShowTaskViewButton = 0
  TaskbarDa = 0
  TaskbarMn = 0
}

Set-ItemProperty 'HKCU:\Control Panel\Mouse' 'MouseSensitivity' 20
Set-ItemProperty 'HKCU:\Software\Microsoft\Accessibility' 'CursorSize' 2
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'SearchboxTaskbarMode' 0

if ($isMobile)
{
  Set-Registry-Values "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" @{
    FourFingerSlideEnabled = 3
    FourFingerTapEnabled   = 3
    RightClickZoneEnabled  = 0
    ThreeFingerTapEnabled  = 4
  }
}
