SetTitleMatchMode "Regex"

ActivateWezTermTab(WindowNumber, TabNumber) {
  WinTitle := "^" . WindowNumber . " ahk_class org\.wezfurlong\.wezterm"
  if WinExist(WinTitle) {
    WinActivate ;
  } else {
    Run "C:\Program Files\WezTerm\wezterm-gui.exe"
  }
  if (TabNumber) {
    WinWaitActive(WinTitle)
    Send "+^" . TabNumber
  }
}

~^!0::ActivateWezTermTab(0, 0)
~^!1::ActivateWezTermTab(0, 1)
~^!2::ActivateWezTermTab(0, 2)
~^!3::ActivateWezTermTab(0, 3)
~^!4::ActivateWezTermTab(0, 4)
~^!5::ActivateWezTermTab(0, 5)
~^!6::ActivateWezTermTab(0, 6)
~^!7::ActivateWezTermTab(0, 7)
~^!8::ActivateWezTermTab(0, 8)
~^!9::ActivateWezTermTab(0, 9)
~+!0::ActivateWezTermTab(1, 0)
~+!1::ActivateWezTermTab(1, 1)
~+!2::ActivateWezTermTab(1, 2)
~+!3::ActivateWezTermTab(1, 3)
~+!4::ActivateWezTermTab(1, 4)
~+!5::ActivateWezTermTab(1, 5)
~+!6::ActivateWezTermTab(1, 6)
~+!7::ActivateWezTermTab(1, 7)
~+!8::ActivateWezTermTab(1, 8)
~+!9::ActivateWezTermTab(1, 9)
