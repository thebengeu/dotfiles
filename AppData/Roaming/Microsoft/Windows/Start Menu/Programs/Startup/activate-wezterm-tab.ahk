#SingleInstance Off
SetTitleMatchMode "Regex"

WinTitle := "ahk_class org\.wezfurlong\.wezterm"

ActivateWezTermTab(WindowNumber, TabNumber) {
  If WinExist(WinTitle) {
    WinActivate ;
  } Else {
    Run A_ProgramsCommon . "\WezTerm.lnk"
  }
  WinWaitActive(WinTitle)
  If (WindowNumber = 1) {
    Send "+!" . TabNumber
  } Else {
    Send "^+!" . TabNumber
  }
}

If A_Args.has(2) {
  ActivateWezTermTab(A_Args[1], A_Args[2])
  ExitApp
} Else {
  #HotIf !WinActive(WinTitle)
  +!0::ActivateWezTermTab(1, 0)
  +!1::ActivateWezTermTab(1, 1)
  +!2::ActivateWezTermTab(1, 2)
  +!3::ActivateWezTermTab(1, 3)
  +!4::ActivateWezTermTab(1, 4)
  +!5::ActivateWezTermTab(1, 5)
  +!6::ActivateWezTermTab(1, 6)
  +!7::ActivateWezTermTab(1, 7)
  +!8::ActivateWezTermTab(1, 8)
  +!9::ActivateWezTermTab(1, 9)
  +!d::ActivateWezTermTab(1, "d")
  +!l::ActivateWezTermTab(1, "l")
  +!n::ActivateWezTermTab(1, "n")
  +!p::ActivateWezTermTab(1, "p")
  +!e::ActivateWezTermTab(1, "s")
  +!v::ActivateWezTermTab(1, "v")
  +!w::ActivateWezTermTab(1, "w")
  ^+!0::ActivateWezTermTab(2, 0)
  ^+!1::ActivateWezTermTab(2, 1)
  ^+!2::ActivateWezTermTab(2, 2)
  ^+!3::ActivateWezTermTab(2, 3)
  ^+!4::ActivateWezTermTab(2, 4)
  ^+!5::ActivateWezTermTab(2, 5)
  ^+!6::ActivateWezTermTab(2, 6)
  ^+!7::ActivateWezTermTab(2, 7)
  ^+!8::ActivateWezTermTab(2, 8)
  ^+!9::ActivateWezTermTab(2, 9)
  ^+!d::ActivateWezTermTab(2, "d")
  ^+!l::ActivateWezTermTab(2, "l")
  ^+!n::ActivateWezTermTab(2, "n")
  ^+!p::ActivateWezTermTab(2, "p")
  ^+!e::ActivateWezTermTab(2, "s")
  ^+!v::ActivateWezTermTab(2, "v")
  ^+!w::ActivateWezTermTab(2, "w")
}
