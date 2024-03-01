#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

While, !FileExist("english.ahk") {
    Sleep, 1000
    Reload
}

SetFormat, Integer, H
Lang := { "EN": 0x4090409, "PE": 0x4290429 }

WinGet, WinID,, A
ThreadID:=DllCall("GetWindowThreadProcessId", "Int", WinID, "Int", "0")
InputLocaleID:=DllCall("GetKeyboardLayout", "Int", ThreadID)

if(InputLocaleID=Lang.EN) {
    ;Run,F:\danny_new_tools\to_be_exported\hars\english.ahk /force
    Run,english.ahk /force
    ExitApp
}

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
; d: sc020
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
; new left shift: sc056
; new right alt: sc138
; old left control: sc01D
; home: sc147
; old right control: sc11D
; n: sc031

; f2: sc03c
; f3: sc03d
; f4: sc03e
; f5: sc03f
; 03a: capslock

*sc035::Send {RShift down}
*sc035 Up::Send {RShift up}
~sc035 & p::Reload

sc01d::Insert
sc02d::LControl

sc034::RControl

sc02F & sc017::SendInput, {r}
sc02f & sc01A::Send ^+2
sc02F & sc018::SendInput, {m}
+sc024::SendInput, +j
+sc032:: SendInput, +m
+sc013:: SendInput, +y
sc03a & sc027:: SendInput, ^c
sc034 & sc010:: SendInput, ^v
sc03a & sc030:: SendInput, ^z
sc034 & sc021:: SendInput, ^f
sc034 & sc01e:: SendInput, ^a

sc027::sc021
sc033 & sc020::SendInput, {e}
+sc033::Send {#}
+sc004::Send +/
sc015::sc033
sc030::sc02c
sc021::sc02f

sc02c::Tab

sc035 & sc02c::+Tab
sc033 & sc02c::!Tab

sc010::sc02e
sc013::sc02b
sc032::sc02d

;switch keyboard layout
;!sc02c::

;typical for lenovo e580
6::f6

sc147::RWin
sc147 & sc020::SendInput #d
sc147 & sc01e::SendInput #a
sc147 & sc012::SendInput #e
sc147 & sc013::#r

sc147 & sc003::send {Media_Next}
sc147 & sc029::send {Media_Prev}
sc147 & sc002::send {Media_Play_Pause}
sc147 & sc004::send {Volume_Mute}
sc147 & sc005::send {Volume_Down}
sc147 & sc006::send {Volume_Up}

;Control Panel
sc147 & sc02c:: run ::{21ec2020-3aea-1069-a2dd-08002b30309d}
return

;task manager
sc147 & sc02d:: run, c:\windows\system32\taskmgr.exe
return

;tools
sc147 & sc021::run, c:\windows\system32\calc.exe
return
sc147 & sc022::run, c:\windows\system32\notepad.exe
return

sc02f & 0::
    SetFormat, Integer, H
    Lang := { "EN": 0x4090409, "PE": 0x4290429 }

    WinGet, WinID,, A
    ThreadID:=DllCall("GetWindowThreadProcessId", "Int", WinID, "Int", "0")
    InputLocaleID:=DllCall("GetKeyboardLayout", "Int", ThreadID)

    if(InputLocaleID=Lang.PE) {
        SendMessage, 0x50,, % Lang.EN,, A
        ;Run,F:\danny_new_tools\to_be_exported\hars\english.ahk /force
        Run,english.ahk /force
        ExitApp
    }
    else if(InputLocaleID=Lang.EN) {
        SendMessage, 0x50,, % Lang.PE,, A
        ;Run,F:\danny_new_tools\to_be_exported\hars\persian.ahk /force
        Run,persian.ahk /force
        ExitApp
    }
return

; sc02f::LControl
sc02f::f7
sc011::sc022
sc022::sc010
sc012::sc027

!sc022::send {^}
sc02f & 9::send {:}
sc033 & sc014::send {6}
sc02F & sc034::send {w}
sc02F & sc035::send {y}
sc033 & sc021::send {b}

return

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
sc03c::LWin

sc03c & sc01b::GoSub,CheckActiveWindow

; lock screen
sc03c & sc027::
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
sc02F & sc030::selectLeftChar()
sc02F & sc031::selectRightChar()
sc033 & sc012::selectEnd()
sc033 & sc02D::selectHome()
sc033 & sc010::selectUp()
sc033 & sc013::selectDown()

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
; LShift & =::Reload

*sc00f::Send {LWin down}
*sc00f Up::Send {LWin up}
return

~sc00f & sc01c::Reload

;^!::MsgBox, %A_ThisHotkey% was pressed.
;return

^[::WheelUp
^]::WheelDown

f9::MButton

sc033 & sc01e::Send {.}
sc033 & sc011::Send {|}

sc02b::sc136

;poweroff
+!9::run, cmd.exe /c c:\windows\system32\sleeping.bat, ,Hide
+!0::run, cmd.exe /c c:\windows\system32\hibernating.bat, ,Hide

;+!-::run, cmd.exe /c shutdown /r, ,Hide
;+!+::run, cmd.exe /c shutdown /s, ,Hide

;^!a::sendInput {Esc}
;^!d::send {Blind} {CapsLock}

; RShift & 1::
;   Run, *RunAs %comspec% /t:60 /k
; return

;terminal
sc03c & sc019::bashHere()

sc03c & sc017::run, wt.exe -d c:\windows\system32
sc03c & sc018::cmdHere()
!sc03e:: !f4

bashHere() {
    If WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass") {
        WinHWND := WinActive()
        For win in ComObjCreate("Shell.Application").Windows
        If (win.HWND = WinHWND) {
            dir := SubStr(win.LocationURL, 9) ; remove "file:///"
            dir := RegExReplace(dir, "%20", " ")
            Break
        }
    }
    Run, "%SYSTEMDRIVE%\Program Files\Git\git-bash.exe", % dir ? dir : A_Desktop
}
return

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
sc03c & sc015::send, {LControl Down} {Home Down} {Home Up} {LControl Up}
sc03c & sc016::send, {LControl Down} {End Down} {End Up} {LControl Up}

;explorer my computer 
; RAlt & e:: run, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}

sc02F & sc024::send, {Down}
sc02F & sc025::send, {Up}
sc02F & sc023::send, {Left}
sc02F & sc026::send, {Right}

sc02F & sc015::send, {LControl down}{Left down}{LControl up}{Left up}
sc02F & sc028::send, {LControl down}{Right down}{LControl up}{Right up}

sc02F & sc027::send, {Enter}
sc02F & sc019::send, {backspace}
sc02F & sc016::send, {LControl down}{backspace down}{LControl up}{backspace up}

sc03c & sc033::send, {PgDn}
sc03c & sc034::send, {PgUp}

sc02F & 7::send {Home}
sc02F & 8::send {End}

sc147 & sc010::
    AdjustScreenBrightness(-5)
Return

sc147 & sc011::
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

sc02c & sc032::WinMinimize, A
sc02c & sc016::WinMaximize, A
sc02c & sc017::ResizeWinLeftHalfUp()
sc02c & sc033::ResizeWinLeftHalfDown()
sc02c & sc035::ResizeWinRightHalfDown()
sc02c & sc019::ResizeWinRightHalfUp()
sc02c & sc018::ResizeWinHalfStart()
sc02c & sc034::ResizeWinHalfEnd()

;RAlt & sc022::ResizeWinHalfEnd()
;RAlt & sc02C::ResizeWinHalfStart()

resizeWinHorizontalRight(direction) {
    WinGetPos, X, Y, Width, Height, A
    WinRestore,A
    if (direction = "right") {
        WinMove,A,,X,Y, Width + A_ScreenWidth / 24, Height
    }
    else {
        WinMove,A,,X,Y, Width - A_ScreenWidth / 24, Height
    }
}

resizeWinVerticalDown(direction) {
    WinGetPos, X, Y, Width, Height, A
    WinRestore,A
    if (direction = "down") {
        WinMove,A,,X,Y, Width , Height + A_ScreenHeight / 34
    }
    else {
        WinMove,A,,X,Y, Width , Height - A_ScreenHeight / 34
    }
}

resizeWinHorizontalLeft(direction) {
    WinGetPos, X, Y, Width, Height, A
    WinRestore,A
    if (direction = "right") {
        WinMove,A,,X + A_ScreenWidth / 24,Y, Width - A_ScreenWidth / 24, Height
    }
    else {
        WinMove,A,,X - A_ScreenWidth / 24,Y, Width + A_ScreenWidth / 24, Height
    }
}

resizeWinVerticalUp(direction) {
    WinGetPos, X, Y, Width, Height, A
    WinRestore,A
    if (direction = "down") {
        WinMove,A,,X,Y + A_ScreenHeight / 34, Width , Height - A_ScreenHeight / 34
    }
    else {
        WinMove,A,,X,Y - A_ScreenHeight / 34, Width , Height + A_ScreenHeight / 34
    }
}

sc02d & sc025::resizeWinVerticalDown("up")
sc02d & sc024::resizeWinVerticalDown("down")
sc02d & sc026::resizeWinHorizontalRight("right")
sc02d & sc023::resizeWinHorizontalRight("left")

sc02d & sc017::resizeWinVerticalUp("up")
sc02d & sc016::resizeWinVerticalUp("down")
sc02d & sc018::resizeWinHorizontalLeft("right")
sc02d & sc015::resizeWinHorizontalLeft("left")

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

f_length(f_type) {
    screen_avg := (A_ScreenHeight + A_ScreenWidth) / 2

    if (f_type == "f4") {
        return screen_avg / 10
    }
    if (f_type == "f3") {
        return screen_avg / 40
    }
    if (f_type == "f2") {
        return screen_avg / 200
    }
}

;/*
sc03d & sc024::MouseMove, 0, f_length("f3"), 0, R
sc03d & sc025::MouseMove, 0, -f_length("f3"), 0, R
sc03d & sc023::MouseMove, -f_length("f3"), 0, 0, R
sc03d & sc026::MouseMove, f_length("f3"), 0, 0, R
;*/

sc03d & sc015::Click
sc03d & sc016::Send ^{Click Left}
sc03d & sc017::Send +{Click Left}
sc03d & sc018::Send !{Click Left}
sc03d & sc019::Click, Right

sc03c & sc024::MouseMove, 0, f_length("f2"), 0, R
sc03c & sc025::MouseMove, 0, -f_length("f2"), 0, R
sc03c & sc023::MouseMove, -f_length("f2"), 0, 0, R
sc03c & sc026::MouseMove, f_length("f2"), 0, 0, R

sc03e & sc024::MouseMove, 0, f_length("f4"), 0, R
sc03e & sc025::MouseMove, 0, -f_length("f4"), 0, R
sc03e & sc023::MouseMove, -f_length("f4"), 0, 0, R
sc03e & sc026::MouseMove, f_length("f4"), 0, 0, R

;fast upper mouse navigation
sc03e & sc017::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth/8, A_ScreenHeight/4, 0
return

sc03e & sc018::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth/2, A_ScreenHeight/4, 0
return

sc03e & sc019::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth - A_ScreenHeight/4, A_ScreenHeight/4, 0
return

;fast lower mouse navigation
sc03e & sc033::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth/8, A_ScreenHeight - A_ScreenHeight/4, 0
return

sc03e & sc034::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth/2, A_ScreenHeight - A_ScreenHeight/4, 0
return

sc03e & sc035::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth - A_ScreenHeight/4, A_ScreenHeight - A_ScreenHeight/4, 0
return

;hide mouse curser
sc03e & sc027::
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth + 20, A_ScreenHeight/2, 0
return

/*
double click
!m::
  send {LButton 2}
Return
*/

sc03d & sc01A::WheelLeft
sc03d & sc01B::WheelRight
sc03d & sc033::WheelDown
sc03d & sc034::WheelUp
sc02F & -::send, !{Left}
sc02F & =::send, !{Right}

sc001::ExitApp ; Exit script with Escape key
RShift::Insert
;drag and drop

*sc03f::
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

sc02e::CapsLock
