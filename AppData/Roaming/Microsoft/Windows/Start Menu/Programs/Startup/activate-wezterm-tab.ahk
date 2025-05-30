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
    For App in ComObject("Shell.Application").NameSpace("shell:AppsFolder").Items {
      (App.Name = Target) && Run("explorer shell:appsFolder\" . App.Path)
    }
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
  ^+!'::ActivateMinimizeOrRun("ahk_exe Perplexity.exe", "Perplexity")
  ^+!/::ActivateMinimizeOrRun("ahk_exe Fantastical.exe", "Fantastical")
  ^+!a::ActivateMinimizeOrRun("ahk_exe Aptakube.exe", "Aptakube")
  ^+!b::ActivateMinimizeOrRun("ahk_exe Obsidian.exe", "Obsidian")
  ^+!c::ActivateMinimizeOrRun("ahk_exe claude.exe", "Claude")
  ^+!e::ActivateMinimizeOrRun("Edge ahk_exe msedge.exe", "Microsoft Edge")
  ^+!f::ActivateMinimizeOrRun("Fastmail ahk_exe msedge.exe", "Fastmail")
  ^+!g::ActivateMinimizeOrRun("ahk_exe chrome.exe", "Google Chrome")
  ^+!h::ActivateMinimizeOrRun("WhatsApp ahk_exe ApplicationFrameHost.exe", "WhatsApp")
  ^+!i::ActivateMinimizeOrRun("ahk_exe ChatGPT.exe", "ChatGPT")
  ^+!j::ActivateMinimizeOrRun("ahk_exe pycharm64.exe", "PyCharm")
  ^+!k::ActivateMinimizeOrRun("ahk_exe WindowsTerminal.exe", "Terminal Preview")
  ^+!l::ActivateMinimizeOrRun("ahk_exe Linear.exe", "Linear")
  ^+!n::ActivateMinimizeOrRun("ahk_exe Notion.exe", "Notion")
  ^+!o::ActivateMinimizeOrRun("Todoist ahk_exe msedge.exe", "Todoist")
  ^+!p::ActivateMinimizeOrRun("NotePlan ahk_exe msedge.exe", "NotePlan")
  ^+!q::ActivateMinimizeOrRun("ahk_exe Spark Desktop.exe", "Spark Desktop")
  ^+!r::ActivateMinimizeOrRun("iCloud Reminders ahk_exe msedge.exe", "iCloud Reminders")
  ^+!s::ActivateMinimizeOrRun("ahk_exe Slack.exe", "Slack")
  ^+!t::ActivateMinimizeOrRun("Unigram ahk_exe ApplicationFrameHost.exe", "Unigram")
  ^+!u::ActivateMinimizeOrRun("ahk_exe Cursor.exe", "Cursor")
  ^+!v::ActivateMinimizeOrRun("ahk_exe Code.exe", "Visual Studio Code")
  ^+!w::ActivateMinimizeOrRun("ahk_exe wezterm-gui.exe", "WezTerm")
  ^+!x::ActivateMinimizeOrRun("ahk_exe firefox.exe", "Firefox")
  ^+!y::ActivateMinimizeOrRun("ahk_exe Spotify.exe", "Spotify")
  ^+!z::ActivateMinimizeOrRun("ahk_exe neovide.exe", "Neovide")
  ^+#r::ActivateMinimizeOrRun("Raindrop.io ahk_exe msedge.exe", "Raindrop.io")
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
