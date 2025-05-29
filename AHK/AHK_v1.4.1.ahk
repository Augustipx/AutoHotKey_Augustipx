; ==============================================
; 键盘映射工具 v1.7.0
; 功能：Win/CapsLock 切换映射模式
; 作者：县道377
; 更新：2025-05-29
; ==============================================

#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"  ; 防止菜单键干扰
SetCapsLockState "AlwaysOff"   ; 初始强制关闭
global Toggle := "AlwaysOff"

; ===================== 系统初始化 =====================
; 自启动设置
try {
    if !FileExist(A_Startup "\AHK_v1.7.0.lnk")
        FileCreateShortcut A_ScriptFullPath, A_Startup "\AHK_v1.7.0.lnk"
} catch Error as e {
    MsgBox "创建开机启动快捷方式失败: " e.Message
}

; ================== CapsLock短按逻辑 ==================
~CapsLock:: {
    key_start := A_TickCount
    KeyWait "CapsLock"
    if (A_TickCount - key_start < 200) {
        SendInput "{Blind}{Esc}"  ; 更可靠的发送方式
    }
}

; ================= CapsLock状态切换 =================
ToggleCapsLock() {
    global Toggle
    if (Toggle == "AlwaysOn") {
        SetCapsLockState "AlwaysOff"
        Toggle := "AlwaysOff"
    } else if (Toggle == "AlwaysOff") {
        SetCapsLockState "AlwaysOn"
        Toggle := "AlwaysOn"
    }
}
#`:: ToggleCapsLock()         ; Win + `
CapsLock & `:: ToggleCapsLock() ; CapsLock + `



; ===================== 常驻映射 =====================
; 多媒体键映射
*Browser_Back::F1
*Browser_Refresh::F2
*PrintScreen::F4

; Win组合键映射
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
#HotIf GetKeyState("CapsLock", "P")
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