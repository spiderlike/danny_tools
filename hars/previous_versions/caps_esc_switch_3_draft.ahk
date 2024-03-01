; If the script is not elevated, relaunch as administrator and kill current instance:
; j: sc024
; k: sc025
; h: sc023
; l: sc026
; u: sc016
; i: sc017
; o: sc018
; p: sc019
; `: sc029
; a: sc01E
; d: sc020
; f: sc021
; m: sc032
; ,: sc033
; ': sc028
; e: sc012
; x: sc02D
; r: sc013
; e: sc012
; y: sc015
; b: sc030
; q: sc010
; v: sc02F
; z: sc02C
; w: sc011
; g: sc022
; c: sc02E
; /: sc035
; \: sc02B
; 3: sc004
; [: sc01A
; ]: sc01B
; t: sc014
; rshift: sc136
; .: sc034
; ;: sc027
; LALT: sc038
; new shift: sc02A
; new right alt: sc138

sc02e::sc027
sc027::sc02e
sc004::sc010
sc015::sc030
sc030::sc02c
sc02c::sc034
sc010::sc02f

;switch keyboard layout
;!sc02c::

getLang() {
  global
  lang1 := ""
  return lang1
}

setLang(lang) {
  global
  lang1 := ""
  if (%lang% = pe) {
    lang1 := pe
  }
  else {
    lang1 := en
  }
}

^Space::
  SetFormat, Integer, H
  Lang := { "EN": 0x4090409, "PE": 0x4290429 }

  WinGet, WinID,, A
  ThreadID:=DllCall("GetWindowThreadProcessId", "Int", WinID, "Int", "0")
  InputLocaleID:=DllCall("GetKeyboardLayout", "Int", ThreadID)

  if(InputLocaleID=Lang.PE) {
    SendMessage, 0x50,, % Lang.EN,, A
    setLang(en)
  }
  else if(InputLocaleID=Lang.EN) {
    SendMessage, 0x50,, % Lang.PE,, A
    setLang(pe)
  }
return

sc02f::LControl
sc011::sc022
sc022::sc035
sc034::sc011
sc035::sc015

!sc022::send {^}
!sc014::send {6}
sc02F & sc035::send {:}

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
  try ; leads to having the script re-launching itself as administrator
  {
    if A_IsCompiled
      Run *RunAs "%A_ScriptFullPath%" /restart
    else
      Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
  }
}

;MsgBox, %A_ThisHotkey% was pressed.
;return

/*
q) vk51 sc010
\) vkdc sc02B
*/
;sc010::sc02B
;sc02B::sc010

; #]::MsgBox, %A_ThisHotkey% was pressed.
sc056::LShift
home::lwin
f2::rwin

f2 & sc01b::GoSub,CheckActiveWindow

; lock screen
f2 & sc027::
  KeyWait f2
  KeyWait \
  DllCall("LockWorkStation")
Return

CheckActiveWindow:
  ID := WinExist("A")
  WinGetClass,Class, ahk_id %ID%
  WClasses := "CabinetWClass ExploreWClass"
  IfInString, WClasses, %Class%
    GoSub, Toggle_HiddenFiles_Display
Return

Toggle_HiddenFiles_Display:
  RootKey = HKEY_CURRENT_USER
  SubKey = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced

  RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden

  if HiddenFiles_Status = 2
    RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1 
  else 
    RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
  PostMessage, 0x111, 41504,,, ahk_id %ID%
Return

;^!i::run, msedge "https://www.bing.com/search?q=Bing+AI&showconv=1&FORM=hpcodx"

;mark text
selectRightWord() {
  ; send {blind} {LShift Down} {Right Down} {Lshift Up} {Right Up}
  ; return
  SendInput, ^+{Right}
return
}

selectLeftWord() {
  ; send {blind} {LShift Down} {Left Down} {Lshift Up} {Left Up}
  ; return
  SendInput, ^+{Left}
return
}

selectRightChar() {
  ; send {blind} {LShift Down} {Right Down} {Lshift Up} {Right Up}
  ; return
  SendInput, +{Right}
return
}
selectLeftChar() {
  ; send {blind} {LShift Down} {Left Down} {Lshift Up} {Left Up}
  ; return
  SendInput, +{Left}
return
}
selectEnd() {
  SendInput, +{End}
return
}

selectHome() {
  SendInput, +{Home}
return
}

selectDown() {
  SendInput, +{Down}
return
}

selectUp() {
  SendInput, +{Up}
return
}

;text selection
sc02F & sc032::selectLeftWord()
sc02F & sc033::selectRightWord()
sc02F & sc028::selectLeftChar()
sc02F & sc02b::selectRightChar()
RAlt & sc012::selectHome()
RAlt & sc02D::selectEnd()
RAlt & sc010::selectUp()
RAlt & sc013::selectDown()

;task view
; taskView() {
;   WinMinimizeAllUndo
;   MouseMove, 77, 743
;   Click 77 743
;   MouseMove, 690, 640
;   Send, {End}
;   Send, {Down}
;   MouseMove, A_ScreenWidth + 10, 640
; return
; }

/*
explorerFocus() {
  send, {Alt Down} {Alt Up}
  sleep 300
  ; sleep 300
  send, {LControl Down} {Tab Down} {Tab Up}
  ; sleep 300
  send, {Tab Down} {Tab Up}
  ; sleep 300
  send, {LControl Up} 
}

^!a::explorerFocus()

*/

;task_view
; ^!a::
;   send, {LWin Down} {Tab Down} {LWin Up} {Tab Up}
;   MouseMove, 690, 640
;   Send, {End}
;   Send, {Down}
;   MouseMove, A_ScreenWidth + 10, 640
; return

/*
;file_manager sort
<your shortcut>::
  ; send, {RControl Down} {RAlt Down} {Tab Down} sleep 200
  send {Blind} !^{Tab}
return

*/

;^+q::white_click()
;^+g::MsgBox, %A_ThisHotkey% was pressed.

;^!w::Pause ; Pause script with Ctrl+Alt+P
;LShift & -::Suspend
LShift & =::Reload

;^!::MsgBox, %A_ThisHotkey% was pressed.
;return

;tools
sc02b & 1::run, cmd.exe /c c:\windows\system32\calc.exe, ,Hide
sc02b & sc029::run, cmd.exe /c c:\windows\system32\notepad.exe, ,Hide

^[::WheelUp
^]::WheelDown
!sc01e::Send {#}
!sc020::Send {3}

!sc021::Send {\}
!sc011::Send {|}

sc02b::sc136

;poweroff
+!9::run, cmd.exe /c c:\windows\system32\sleeping.bat, ,Hide
+!0::run, cmd.exe /c c:\windows\system32\hibernating.bat, ,Hide

;+!-::run, cmd.exe /c shutdown /r, ,Hide
;+!+::run, cmd.exe /c shutdown /s, ,Hide

sc02b & 6:: run, cmd.exe /c c:\windows\system32\taskmgr.exe, ,Hide

;^!a::sendInput {Esc}
;^!d::send {Blind} {CapsLock}

; RShift & 1::
;   Run, *RunAs %comspec% /t:60 /k
; return

;terminal
;^!a::run, wt.exe -d c:\windows\system32
;^!d::cmdHere()

cmdHere() {
  If WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass") {
    WinHWND := WinActive()
    For win in ComObjCreate("Shell.Application").Windows
    If (win.HWND = WinHWND) {
      dir := SubStr(win.LocationURL, 9) ; remove "file:///"
      dir := RegExReplace(dir, "%20", " ")
      Break
    }
  }
  Run, %comspec%, % dir ? dir : A_Desktop
}
return

PrintScreen::RControl
RControl::RShift
BackSpace::Del
Del::BackSpace
f2 & sc015::send, {LControl Down} {Home Down} {Home Up} {LControl Up}
f2 & sc016::send, {LControl Down} {End Down} {End Up} {LControl Up}

;Control Panel
sc02b & F4:: run ::{21ec2020-3aea-1069-a2dd-08002b30309d}
return

;explorer my computer 
; RAlt & e:: run, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}

sc02F & sc024::send, {Down}
sc02F & sc025::send, {Up}
sc02F & sc023::send, {Left}
sc02F & sc026::send, {Right}

sc02F & sc015::send, {LControl down}{Left down}{LControl up}{Left up}
sc02F & sc034::send, {LControl down}{Right down}{LControl up}{Right up}

sc02F & sc027::send, {Enter}
sc02F & sc019::send, {backspace}
sc02F & sc016::send, {LControl down}{backspace down}{LControl up}{backspace up}

f2 & sc033::send, {PgDn}
f2 & sc034::send, {PgUp}

sc02b & 5::send {Media_Next}
sc02b & sc004::send {Media_Prev}
sc02b & 4::send {Media_Play_Pause}
sc02b & f1::send {Volume_Mute}
sc02b & f2::send {Volume_Down}
sc02b & f3::send {Volume_Up}

sc02F & 7::send {Home}
sc02F & 8::send {End}

sc02b & f5::
  AdjustScreenBrightness(-5)
Return

sc02b & f6::
  AdjustScreenBrightness(5)
Return

AdjustScreenBrightness(step) {
  service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"
  monitors := ComObjGet(service).ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE")
  monMethods := ComObjGet(service).ExecQuery("SELECT * FROM wmiMonitorBrightNessMethods WHERE Active=TRUE")
  minBrightness := 5 ; level below this is identical to this

  for i in monitors {
    curt := i.CurrentBrightness
    break
  }
  if (curt < minBrightness) ; parenthesis is necessary here
    curt := minBrightness
  toSet := curt + step
  if (toSet > 100)
    return
  if (toSet < minBrightness)
    toSet := minBrightness

  for i in monMethods {
    i.WmiSetBrightness(1, toSet)
    break
  }
}

;resize window

ResizeWinLeftHalfUp()
{
  WinRestore,A
  WinMove,A,,1,1,A_ScreenWidth/2 - A_ScreenWidth / 16, A_ScreenHeight/2 - A_ScreenHeight / 16
}

ResizeWinLeftHalfDown()
{
  WinRestore,A
  WinMove,A,,1,A_ScreenHeight/2 - A_ScreenHeight / 16,A_ScreenWidth/2 - A_ScreenWidth / 16, A_ScreenHeight/2
}

ResizeWinRightHalfUp()
{
  WinRestore,A
  WinMove,A,,A_ScreenWidth/2 - A_ScreenWidth / 16,1,A_ScreenWidth/2 + A_ScreenWidth / 16, A_ScreenHeight/2 - A_ScreenHeight / 16
}

ResizeWinRightHalfDown()
{
  WinRestore,A
  WinMove,A,,A_ScreenWidth/2 - A_ScreenWidth / 16,A_ScreenHeight/2 - A_ScreenHeight / 16,A_ScreenWidth/2 + A_ScreenWidth / 16, A_ScreenHeight/2
}

ResizeWinHalfEnd()
{
  WinRestore,A
  WinMove,A,,A_ScreenWidth/2 - A_ScreenWidth / 16,1,A_ScreenWidth/2 + A_ScreenWidth / 16 , A_ScreenHeight - A_ScreenHeight / 16
}

ResizeWinHalfStart()
{
  WinRestore,A
  WinMove,A,,1,1,A_ScreenWidth/2 - A_ScreenWidth / 16, A_ScreenHeight - A_ScreenHeight / 16
}

!sc032::WinMinimize, A
!sc016::WinMaximize, A

!sc017::ResizeWinLeftHalfUp()
!sc033::ResizeWinLeftHalfDown()
!sc035::ResizeWinRightHalfDown()
!sc019::ResizeWinRightHalfUp()
!sc018::ResizeWinHalfStart()
!sc034::ResizeWinHalfEnd()

;RAlt & sc022::ResizeWinHalfEnd()
;RAlt & sc02C::ResizeWinHalfStart()
!sc01A::WinRestore,A

SetCapsLockState Off

WaitingForCtrlInput := false
SentCtrlDownWithKey := false

*CapsLock::
  key := 
  WaitingForCtrlInput := true
  Input, key, B C L1 T1, {Esc}
  WaitingForCtrlInput := false
  if (ErrorLevel = "Max") {
    SentCtrlDownWithKey := true
    Send {Ctrl Down}%key%
  }
  KeyWait, CapsLock
Return

*CapsLock up::
  If (SentCtrlDownWithKey) {
    Send {Ctrl Up}
    SentCtrlDownWithKey := false
  } else {
    if (A_TimeSincePriorHotkey < 1000) {
      if (WaitingForCtrlInput) {
        Send, {Esc 2}
      } else {
        Send, {Esc}
      }
    }
  }
Return

SetCapsLockState, Off
width := A_ScreenWidth - 202
height := A_ScreenHeight - 70

LControl::CapsLock

;#y::SendInput, {F6}

f_length(f_type) {
  screen_avg := (A_ScreenHeight + A_ScreenWidth) / 2

  if (f_type == "f4") {
    return screen_avg / 10
  }
  if (f_type == "f3") {
    return screen_avg / 40
  }
  if (f_type == "f2") {
    return screen_avg / 80
  }
}

;/*
f3 & sc024::MouseMove, 0, f_length("f3"), 0, R
f3 & sc025::MouseMove, 0, -f_length("f3"), 0, R
f3 & sc023::MouseMove, -f_length("f3"), 0, 0, R
f3 & sc026::MouseMove, f_length("f3"), 0, 0, R
;*/

f3 & sc015::Click
f3 & sc016::Send ^{Click Left}
f3 & sc017::Send +{Click Left}
f3 & sc018::Send !{Click Left}
f3 & sc019::Click, Right

f2 & sc024::MouseMove, 0, f_length("f2"), 0, R
f2 & sc025::MouseMove, 0, -f_length("f2"), 0, R
f2 & sc023::MouseMove, -f_length("f2"), 0, 0, R
f2 & sc026::MouseMove, f_length("f2"), 0, 0, R

f4 & sc024::MouseMove, 0, f_length("f4"), 0, R
f4 & sc025::MouseMove, 0, -f_length("f4"), 0, R
f4 & sc023::MouseMove, -f_length("f4"), 0, 0, R
f4 & sc026::MouseMove, f_length("f4"), 0, 0, R

;fast upper mouse navigation
f4 & sc017::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth/8, A_ScreenHeight/4, 0
return

f4 & sc018::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth/2, A_ScreenHeight/4, 0
return

f4 & sc019::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth - A_ScreenHeight/4, A_ScreenHeight/4, 0
return

;fast lower mouse navigation
f4 & sc033::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth/8, A_ScreenHeight - A_ScreenHeight/4, 0
return

f4 & sc034::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth/2, A_ScreenHeight - A_ScreenHeight/4, 0
return

f4 & sc035::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth - A_ScreenHeight/4, A_ScreenHeight - A_ScreenHeight/4, 0
return

;hide mouse curser
f4 & sc027::
  CoordMode, Mouse, Screen
  MouseMove, A_ScreenWidth + 20, A_ScreenHeight/2, 0
return

/*
double click
!m::
  send {LButton 2}
Return
*/

f3 & sc01A::WheelLeft
f3 & sc01B::WheelRight
f3 & sc033::WheelDown
f3 & sc034::WheelUp
sc02F & -::send, !{Left}
sc02F & =::send, !{Right}

esc::Insert
;drag and drop

*f5::
  MouseGetPos, xpos, ypos
  Click, %xpos%, %ypos%, down
  Loop
  {
    Sleep, 10
    if !GetKeyState("f5", "P")
      break
    if GetKeyState("j") {
      MouseGetPos, xpos, ypos
      MouseMove, 0, f_length("f3"), 0, R
      KeyWait, %A_ThisHotkey%
    }
    if GetKeyState("k") {
      MouseGetPos, xpos, ypos
      MouseMove, 0, -f_length("f3"), 0, R
      KeyWait, %A_ThisHotkey%
    }
    if GetKeyState("l") {
      MouseGetPos, xpos, ypos
      MouseMove, f_length("f3"), 0, 0, R
      KeyWait, %A_ThisHotkey%
    }
    if GetKeyState("h") {
      MouseGetPos, xpos, ypos
      MouseMove, -f_length("f3"), 0, 0, R
      KeyWait, %A_ThisHotkey%
    }
  }
  Click, up
  MouseGetPos, xpos, ypos
  SoundBeep, 1000, 20
return

#If, getLang() == pe
  ^+sc022::MsgBox, persian
sc02F & sc017::SendInput, {ک}
sc02f & sc01A::Send {‌}
sc02F & sc01B::Send {پ}

#If, getLang() == en
  ^+sc022::MsgBox, english
sc02F & sc018::SendInput, {ط}