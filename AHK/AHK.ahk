; ==============================================
; 键盘映射工具 v2.0.0
; 功能：Win/CapsLock 切换映射模式
; ==============================================
#Requires AutoHotkey v2.0.2
#SingleInstance Force
Persistent
#Warn All
SetWorkingDir A_ScriptDir

; ===================== 性能优化配置 =====================
ProcessSetPriority "High"  ; 提高脚本优先级
ListLines 0                ; 禁用行日志提升性能
SendMode "Input"           ; 使用最快的SendInput模式
SetKeyDelay -1, -1         ; 消除按键延迟
SetWinDelay -1             ; 优化窗口操作
SetControlDelay -1         ; 优化控件操作
A_MenuMaskKey := "vkE8"    ; 防止菜单键干扰
SetCapsLockState "AlwaysOff"
global Toggle := false     ; 使用布尔值更高效
; ===================== 系统初始化 =====================
; 自启动设置
try {
    if !FileExist(A_Startup "\AHK.lnk")
        FileCreateShortcut A_ScriptFullPath, A_Startup "\AHK.lnk"
} catch Error as e {
    MsgBox "创建开机启动快捷方式失败: " e.Message
}

; ================= CapsLock状态切换 =================
ToggleCapsLock() {
    static lastToggleTime := 0
    global Toggle

    if (Toggle) {
        SetCapsLockState "AlwaysOff"
        Toggle := false
    } else {
        SetCapsLockState "AlwaysOn"
        Toggle := true
    }
    lastToggleTime := A_TickCount
}

#` Up:: ToggleCapsLock()         ; Win + `
CapsLock & ` up:: ToggleCapsLock() ; CapsLock + `

; ===================== 常驻映射 =====================
*Browser_Back:: F1
*Browser_Refresh:: F2
*PrintScreen:: F4

; 符号键重映射
*`::Esc
*Esc::`
*CapsLock::LWin

; Win组合键映射 (使用直接语法)
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
#Left::Home
#Right::End
#Up::PgUp
#Down::PgDn
#Enter::^+Esc
#+i::Insert
#Backspace::Delete

; ================= CapsLock组合键映射 =================
#HotIf GetKeyState("CapsLock", "P")  ; 使用物理按下状态
e::#e
d::#d
r::#r
x::#x
v::#v
.::#.
i::#i
+i::Insert
1::F1
2::F2
3::F3
4::F4
5::F5
6::F6
7::F7
8::F8
9::F9
0::F10
-::F11
=::F12
Tab::#Tab
BackSpace::Delete
Left::Home
Right::End
Up::PgUp
Down::PgDn
Enter::^+Esc
#HotIf