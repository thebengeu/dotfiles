SetTitleMatchMode "Regex"

SetTimer EnterBrightDataPassword, 200

EnterBrightDataPassword() {
  if WinActive("Authentication Required - Mozilla Firefox") {
    SendText "lum-customer-hl_f1516e39-zone-isp-dns-remote`t27053p9y19rt`n"
  }
}

Tmux(SessionName, WindowNumber) {
  WinTitle := "^" . SessionName . " ahk_class org\.wezfurlong\.wezterm"
  if WinExist(WinTitle) {
    WinActivate ;
  } else {
    Run "C:\Program Files\WezTerm\wezterm-gui.exe start -- tmux new-session -A -s " . SessionName
  }
  if (WindowNumber) {
    WinWaitActive(WinTitle)
    Send "^{Space}" . WindowNumber
  }
}

^!0::Tmux(0, 0)
^!1::Tmux(0, 1)
^!2::Tmux(0, 2)
^!3::Tmux(0, 3)
^!4::Tmux(0, 4)
^!5::Tmux(0, 5)
^!6::Tmux(0, 6)
^!7::Tmux(0, 7)
^!8::Tmux(0, 8)
^!9::Tmux(0, 9)
+!0::Tmux(1, 0)
+!1::Tmux(1, 1)
+!2::Tmux(1, 2)
+!3::Tmux(1, 3)
+!4::Tmux(1, 4)
+!5::Tmux(1, 5)
+!6::Tmux(1, 6)
+!7::Tmux(1, 7)
+!8::Tmux(1, 8)
+!9::Tmux(1, 9)
