; ==============================================
; 键盘映射工具 v1.4.3
; 功能：Win/CapsLock 切换映射模式
; 作者：县道377
; 更新：2025-05-20
; ==============================================

#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"
SetCapsLockState("AlwaysOff")
*CapsLock::LWin
; ===================== 系统初始化 =====================

; 自启动设置
try {
    if !FileExist(A_Startup "\AHK_v1.4.1.lnk")
        FileCreateShortcut A_ScriptFullPath, A_Startup "\AHK_v1.4.1.lnk"
} catch Error as e {
    MsgBox "创建开机启动快捷方式失败: " e.Message
}

; ===================== 常驻映射 =====================
; 多媒体键映射
*Browser_Back::Delete
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
#`::Insert
#Left::Home
#Right::End
#Up::PgUp
#Down::PgDn
#Enter::^+Esc
; CapsLock组合键映射
#HotIf GetKeyState("CapsLock", "P")
e::#e
d::#d
r::#r
x::#x
v::#v
.::#.
Esc::#Esc
Enter::^+Esc
#HotIf