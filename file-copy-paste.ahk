#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

fileName := "D:\demo.cp"
tipDelay := -800

#c::
    wf := FileOpen(fileName, "w", "UTF-8")
    If (!IsObject(wf)){
        tip("open file failed",tipDelay)
        return
    }
    temp := clipboard
    clipboard := ""
    send ^c
    ClipWait, 0.5,1
    if (ErrorLevel){
        tip("opy failed.", tipDelay)
    }Else{
        tip("success." , tipDelay)
        wf.write(clipboard)
    }
    wf.close()
    clipboard := temp
    temp := ""
return

#v::
    rf := FileOpen(fileName,"r","UTF-8")
    if(!IsObject(rf)){
        tip("file not found.",tipDelay)
    }Else{
        rTemp := clipboard
        clipboard := rf.Read(rf.Length)
        send ^v
        Sleep, 40
        clipboard := rTemp
        rTemp := ""
    }
    rf.Close()
    FileDelete,%fileName%
return


tip(str,t){
    MouseGetPos, mouse_x, mouse_y
    ToolTip, %str%, %mouse_x% + 200, %mouse_y%, 1
    SetTimer, RemoveToolTip, %t%

}
RemoveToolTip:
ToolTip
return
