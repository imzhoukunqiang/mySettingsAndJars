#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetStoreCapslockMode, off
global keyPressed := False


; /sj  -> yyyy-MM-dd HH:mm:ss
; /rq  -> yyyy-MM-dd 
; /time  -> HH:mm:ss

; RAlt +  Q W E -> 7 8 9
; RAlt +   A S D -> 4 5 6
; RAlt +    Z X C -> 1 2 3
; RAlt +       space ->0

; CapsLock +   I   ->    ↑ 
; CapsLock + J K L -> ←  ↓  →

; CapsLock + Q W E R ->  Ins Home PgUp Backspace
; CapsLock +  A S D  ->  Del End  PgDn

;  增强复制 ctrl+shift+c ：选中文件即可复制路径


intInterval := 300 ; 若两次连击在这个时间间隔中，则视为双击。
$CapsLock::
if (A_PriorHotkey <> "$CapsLock" or A_TimeSincePriorHotkey > intInterval)
{
    KeyWait, CapsLock
    return
}
Send, {CapsLock}
return

NumpadAdd::return

NumpadAdd & Z:: press(1)
NumpadAdd & X:: press(2)
NumpadAdd & C:: press(3)
NumpadAdd & A:: press(4)
NumpadAdd & S:: press(5)
NumpadAdd & D:: press(6)
NumpadAdd & Q:: press(7)
NumpadAdd & W:: press(8)
NumpadAdd & E:: press(9)
NumpadAdd & Space:: press(0)

NumpadAdd & P:: press_blind("Up")
NumpadAdd & sc027:: press_blind("Down")    ;027->;
NumpadAdd & L:: press_blind("Left")
NumpadAdd & sc028:: press_blind("Right")   ;028->'

~CapsLock & R:: press_blind("Backspace")
~CapsLock & Q:: press_blind("Insert")
~CapsLock & W:: press_blind("Home")
~CapsLock & E:: press_blind("PgUp")
~CapsLock & A:: press_blind("Delete")
~CapsLock & S:: press_blind("End")
~CapsLock & D:: press_blind("PgDn")


; $Capslock::
;     keyPressed:=False
;     KeyWait, CapsLock
;     If (!keyPressed){
;         Send, {CapsLock}
;     }
; Return


;CapsLock 
;
press(key){
    keyPressed:=true
    SendInput {%key%}
}   

press_blind(key){
    keyPressed:=true
    SendInput {Blind}{%key%}
}

;  2018-12-19 17:26:38


::/sj::
    str := format_now("yyyy-MM-dd HH:mm:ss")
    SendInput, %str% ;
return

::/rq::
    str := format_now("yyyy-MM-dd")
    SendInput,%str%
return

::/time::
    str := format_now("HH:mm:ss")
    SendInput,%str%
return


; 增强复制 ctrl+shift+c
$^+c::
    SetTitleMatchMode, RegEx
    shielded := WinActive("ahk_exe i)chrome\.exe|idea\w*\.exe")
    SetTitleMatchMode, 1
    if (shielded){
        send ^+c
        return
    }

    temp = %clipboard%
    clipboard = 
    send ^c
    ClipWait, 0.5,1
    if (ErrorLevel){
        tip("failed.", -1000)
        clipboard = %temp%
        return
    }
    clipboard=%clipboard% ;%null%
    tip("Copied:`n"+clipboard,-1000)
return

tip(str,t){
    MouseGetPos, mouse_x, mouse_y
    ToolTip, %str%, %mouse_x% + 200, %mouse_y%, 1
    SetTimer, RemoveToolTip, %t%

}
RemoveToolTip:
ToolTip
return

;


format_now(format_str){
    FormatTime, CurrentDateTime,, %format_str% ; 
    return CurrentDateTime
}