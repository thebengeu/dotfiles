SetTitleMatchMode "Regex"

ActivateWezTermTab(WindowNumber, TabNumber) {
  WinTitle := "ahk_class org\.wezfurlong\.wezterm"
  if WinExist(WinTitle) {
    WinActivate ;
  } else {
    Run "C:\Program Files\WezTerm\wezterm-gui.exe"
  }
  WinWaitActive(WinTitle)
  Send "+!^" . WindowNumber
  if (TabNumber) {
    Send "+^" . TabNumber
  }
}

~^!0::ActivateWezTermTab(1, 0)
~^!1::ActivateWezTermTab(1, 1)
~^!2::ActivateWezTermTab(1, 2)
~^!3::ActivateWezTermTab(1, 3)
~^!4::ActivateWezTermTab(1, 4)
~^!5::ActivateWezTermTab(1, 5)
~^!6::ActivateWezTermTab(1, 6)
~^!7::ActivateWezTermTab(1, 7)
~^!8::ActivateWezTermTab(1, 8)
~^!9::ActivateWezTermTab(1, 9)
~+!0::ActivateWezTermTab(2, 0)
~+!1::ActivateWezTermTab(2, 1)
~+!2::ActivateWezTermTab(2, 2)
~+!3::ActivateWezTermTab(2, 3)
~+!4::ActivateWezTermTab(2, 4)
~+!5::ActivateWezTermTab(2, 5)
~+!6::ActivateWezTermTab(2, 6)
~+!7::ActivateWezTermTab(2, 7)
~+!8::ActivateWezTermTab(2, 8)
~+!9::ActivateWezTermTab(2, 9)
