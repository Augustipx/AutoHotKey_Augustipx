; ==============================================
; 键盘映射工具 v3.1.0
; 功能：Win/CapsLock 切换映射模式
; 注册表改键主要是适配Chrome OS键盘(无CapsLk键)
; ==============================================

#Requires AutoHotkey v2.0
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
A_MenuMaskKey := "vkE8"    ; 防止菜单键

; ===================== 系统初始化 =======================
try {
    if !FileExist(A_Startup "\AHK.lnk")
        FileCreateShortcut A_ScriptFullPath, A_Startup "\AHK.lnk"
} catch Error as e {
    MsgBox "创建开机启动快捷方式失败: " e.Message
}

; ===================== 修改注册表映射 ====================
RegKey := "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
ValueName := "Scancode Map"
correctMap :=
    "00000000" .
    "00000000" .
    "03000000" .
    "5BE038E0" . ;RAlt -> LWin
    "3A005BE0" . ;LWin -> CapsLk
    "00000000"
RegWrite(correctMap, "REG_BINARY", RegKey, ValueName)
;;恢复注册表
; RegDelete("HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout", "Scancode Map")
; MsgBox("已删除所有键位映射。`n请重启电脑生效。", "注册表已恢复", "Iconi")

; ===================== 常驻映射 ==========================
*Browser_Back::F1
*Browser_Refresh::F2
*PrintScreen::F4
SetCapsLockState "AlwaysOff"

; ===================== CapsLock键映射处理 =================
; 如果没有其他按键按下,发送Esc键
*CapsLock:: {
    if KeyWait("CapsLock") {
        if !A_PriorKey || A_PriorKey = "CapsLock" {
            SendInput "{Blind}{Esc}"
        }
    }
}
CapsLock & e::#e
CapsLock & d::#d
CapsLock & r::#r
CapsLock & x::#x
CapsLock & v::#v
CapsLock & i::#i
CapsLock & `::Insert
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
CapsLock & Tab::#Tab
CapsLock & BackSpace::Delete
CapsLock & Left::Home
CapsLock & Right::End
CapsLock & Up::PgUp
CapsLock & Down::PgDn
CapsLock & Enter::^+Esc
CapsLock & c Up:: CapsState.toggle()
CapsLock & p:: SendInput "{Blind}{Up}"
CapsLock & `;:: SendInput "{Blind}{Down}"
CapsLock & l:: SendInput "{Blind}{Left}"
CapsLock & ':: SendInput "{Blind}{Right}"
CapsLock & [:: SendInput "{Blind}{Home}"
CapsLock & ]:: SendInput "{Blind}{End}"
CapsLock & .:: SendInput "{Blind}{Ctrl Down}{Right}{Ctrl Up}"
CapsLock & ,:: SendInput "{Blind}{Ctrl Down}{Left}{Ctrl Up}"

; ================= CapsLock状态切换 ====================
class CapsState {
    static state := false
    static toggle() {
        this.state := !this.state
        SetCapsLockState this.state ? "AlwaysOn" : "AlwaysOff"
        return this.state
    }
    static get() {
        return this.state
    }
}