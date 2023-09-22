#SingleInstance Off
SetTitleMatchMode "Regex"

ActivateWezTermTab(WindowNumber, TabNumber) {
  WinTitle := "ahk_class org\.wezfurlong\.wezterm"
  if WinExist(WinTitle) {
    WinActivate ;
  } else {
    Run A_ProgramsCommon . "\WezTerm.lnk"
  }
  WinWaitActive(WinTitle)
  Send "+!^" . WindowNumber
  if (TabNumber) {
    Send "+^" . TabNumber
  }
}

If A_Args.has(2) {
  ActivateWezTermTab(A_Args[1], A_Args[2])
  ExitApp
} Else {
  ^!0::ActivateWezTermTab(1, 0)
  ^!1::ActivateWezTermTab(1, 1)
  ^!2::ActivateWezTermTab(1, 2)
  ^!3::ActivateWezTermTab(1, 3)
  ^!4::ActivateWezTermTab(1, 4)
  ^!5::ActivateWezTermTab(1, 5)
  ^!6::ActivateWezTermTab(1, 6)
  ^!7::ActivateWezTermTab(1, 7)
  ^!8::ActivateWezTermTab(1, 8)
  ^!9::ActivateWezTermTab(1, 9)
  ^!d::ActivateWezTermTab("d", 0)
  ^!e::ActivateWezTermTab("e", 0)
  ^!l::ActivateWezTermTab("l", 0)
  ^!n::ActivateWezTermTab("n", 0)
  ^!p::ActivateWezTermTab("p", 0)
  ^!v::ActivateWezTermTab("v", 0)
  ^!w::ActivateWezTermTab("w", 0)
  +!0::ActivateWezTermTab(2, 0)
  +!1::ActivateWezTermTab(2, 1)
  +!2::ActivateWezTermTab(2, 2)
  +!3::ActivateWezTermTab(2, 3)
  +!4::ActivateWezTermTab(2, 4)
  +!5::ActivateWezTermTab(2, 5)
  +!6::ActivateWezTermTab(2, 6)
  +!7::ActivateWezTermTab(2, 7)
  +!8::ActivateWezTermTab(2, 8)
  +!9::ActivateWezTermTab(2, 9)
}
