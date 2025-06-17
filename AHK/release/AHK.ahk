; ==============================================================
; 键盘映射工具 v3.9.9
; 功能：Win/CapsLock 切换映射模式
; ==============================================================
#Requires AutoHotkey v2.0
#InputLevel 1
#SingleInstance Force
InstallKeybdHook
Persistent
#Warn All
SetWorkingDir A_ScriptDir

; ===================== 性能优化配置 =============================
ProcessSetPriority "High"  ; 提升到最高优先级
ListLines 0                ; 禁用行日志提升性能
SetWinDelay -1             ; 优化窗口操作
SetControlDelay -1         ; 优化控件操作
A_HotkeyInterval := 50     ; 此为默认值 (毫秒).
A_MaxHotkeysPerInterval := 200
Thread "Interrupt", 0
A_MenuMaskKey := "vkE8"    ; 防止菜单键

; ===================== 系统初始化 =================================
startupLink := A_Startup "\AHK.lnk"
if !FileExist(startupLink)
    FileCreateShortcut(A_ScriptFullPath, startupLink)

; ===================== 常驻映射 ====================================
*Browser_Back::F1
*Browser_Refresh::F2
*PrintScreen::F4
SetCapsLockState "AlwaysOff"

; ===================== CapsLock键映射处理 ===========================
CapsLock:: SendEvent "{Esc}"
CapsLock & `::Insert
CapsLock & e::#e
CapsLock & d::#d
CapsLock & r::#r
CapsLock & x::#x
CapsLock & v::#v
CapsLock & 1::F1
CapsLock & 2::F2
CapsLock & 3::F3
CapsLock & 4::F4
CapsLock & 5::F5
CapsLock & 6::F6
CapsLock & 7::F7
CapsLock & 8::F8
CapsLock & 9::F9
CapsLock & 0::F10
CapsLock & -::F11
CapsLock & =::F12
CapsLock & Up::PgUp
CapsLock & Tab::#Tab
CapsLock & Left::Home
CapsLock & Right::End
CapsLock & Down::PgDn
CapsLock & Enter::^+Esc
CapsLock & BackSpace::Delete
CapsLock & w up:: SendEvent "{LWin}"
CapsLock & c up:: CapsState.toggle()

; ===================== Win键映射 ===================================
#1::F1
#2::F2
#3::F3
#4::F4
#5::F5
#6::F6
#7::F7
#8::F8
#9::F9
#0::F10
#-::F11
#=::F12
#>!=::#=
#>!-::#-
#Up::PgUp
#`::Insert
#Left::Home
#Right::End
#Down::PgDn
#Enter::^+Esc
#BackSpace::Delete
#c up:: CapsState.toggle()
#w up:: SendEvent "{LWin}"
~LWin:: {
    Send "{Blind}{vkE8}"
    if !IsLongPress("LWin")
        SendEvent "{Blind}{Esc}"
}

; ===================== 亮度声音控制 ===================================
>!-:: SendEvent("{Volume_Down}")
>!=:: SendEvent("{Volume_Up}")
>!0:: SendEvent("{Volume_Mute}")

; ===================== 控制方法 ===================================
IsLongPress(key, longPressTime := 200) {
    startTime := A_TickCount
    KeyWait key
    pressTime := A_TickCount - startTime
    return pressTime >= longPressTime
}

class CapsState {
    static state := false
    static toggle() {
        this.state := !this.state
        SetCapsLockState (this.state ? "AlwaysOn" : "AlwaysOff")
    }
}