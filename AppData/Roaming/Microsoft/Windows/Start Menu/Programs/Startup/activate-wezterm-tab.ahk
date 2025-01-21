#SingleInstance Off
SetCapsLockState "AlwaysOff"

#InputLevel 1
*CapsLock::
{
  Send("{Ctrl Down}")
  KeyWait("CapsLock")
  Send("{Ctrl Up}")
  if (A_PriorKey == "CapsLock") {
      Send("{Esc}")
  }
}

RAlt::
{
  Send("{Ctrl Down}{Shift Down}{Alt Down}")
  KeyWait("RAlt")
  Send("{Ctrl Up}{Shift Up}{Alt Up}")
}

PrintScreen & e::Up
PrintScreen & s::Left
PrintScreen & d::Down
PrintScreen & f::Right
RCtrl::PrintScreen
#InputLevel 0

ActivateMinimizeOrRun(WinTitle, Target, MinimizeIfActive := true) {
  If WinExist(WinTitle) {
    If MinimizeIfActive && WinActive() {
      WinMinimize ;
    } Else {
      WinActivate ;
    }
  } Else {
    Run Target
  }
}

ActivateWezTermTab(TabNumber) {
  ActivateMinimizeOrRun("ahk_exe wezterm-gui.exe", "wezterm-gui.exe", false)
  WinWaitActive ;
  Send "^+!" . TabNumber
}

If A_Args.has(1) {
  ActivateWezTermTab(A_Args[1])
  ExitApp
} Else {
  ^+!c::ActivateMinimizeOrRun("ahk_exe chrome.exe", A_ProgramsCommon . "\Google Chrome")
  ^+!e::ActivateMinimizeOrRun("Edge ahk_exe msedge.exe", A_ProgramsCommon . "\Microsoft Edge")
  ^+!g::ActivateMinimizeOrRun("Unigram ahk_exe ApplicationFrameHost.exe", "explorer.exe shell:AppsFolder\38833FF26BA1D.UnigramPreview_g9c9v27vpyspw!App")
  ^+!n::ActivateMinimizeOrRun("ahk_exe Notion.exe", A_Programs . "\Notion")
  ^+!o::ActivateMinimizeOrRun("ahk_exe Obsidian.exe", A_Programs . "\Obsidian")
  ^+!p::ActivateMinimizeOrRun("ahk_exe Spark Desktop.exe", A_Programs . "\Spark Desktop")
  ^+!r::ActivateMinimizeOrRun("Raindrop.io ahk_exe msedge.exe", "explorer.exe shell:AppsFolder\app.raindrop.io-7CE7CC2C_he0z7cth5st3m!App")
  ^+!s::ActivateMinimizeOrRun("ahk_exe Slack.exe", A_ProgramsCommon . "\Slack Technologies Inc\Slack")
  ^+!t::ActivateMinimizeOrRun("Todoist ahk_exe msedge.exe", "explorer.exe shell:AppsFolder\app.todoist.com-4794784_5r3ptnqrybf3c!App")
  ^+!w::ActivateMinimizeOrRun("ahk_exe wezterm-gui.exe", "wezterm-gui.exe")
  #HotIf !WinActive("ahk_exe wezterm-gui.exe")
  ^+!1::ActivateWezTermTab(1)
  ^+!2::ActivateWezTermTab(2)
  ^+!3::ActivateWezTermTab(3)
  ^+!4::ActivateWezTermTab(4)
  ^+!5::ActivateWezTermTab(5)
  ^+!6::ActivateWezTermTab(6)
  ^+!7::ActivateWezTermTab(7)
  ^+!8::ActivateWezTermTab(8)
  ^+!9::ActivateWezTermTab(9)
  +!d::ActivateWezTermTab("d")
  +!l::ActivateWezTermTab("l")
  +!n::ActivateWezTermTab("n")
  +!p::ActivateWezTermTab("p")
  +!e::ActivateWezTermTab("s")
  +!v::ActivateWezTermTab("v")
  +!w::ActivateWezTermTab("w")
}
