; =======================================================
; 键盘映射工具 v3.1.0
; 功能：Win/CapsLock 切换映射模式
; 注册表改键主要是适配Chrome OS键盘(无CapsLk键)
; =======================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
InstallKeybdHook  ; 启用底层键盘钩子
Persistent
#Warn All
SetWorkingDir A_ScriptDir


; ===================== 性能优化配置 =====================
ProcessSetPriority "Realtime"  ; 提升到最高优先级
DllCall("winmm\timeBeginPeriod", "UInt", 1)
ListLines 0                ; 禁用行日志提升性能
SetWinDelay -1             ; 优化窗口操作
SetControlDelay -1         ; 优化控件操作
A_HotkeyInterval := 50     ; 此为默认值 (毫秒).
A_MaxHotkeysPerInterval := 500
Thread "Interrupt", 0
A_MenuMaskKey := "vkE8"    ; 防止菜单键

; ===================== 系统初始化 =================================
try {
    if !FileExist(A_Startup "\AHK.lnk")
        FileCreateShortcut A_ScriptFullPath, A_Startup "\AHK.lnk"
} catch Error as e {
    MsgBox "创建开机启动快捷方式失败: " e.Message
}

; ===================== 修改注册表映射 =============================
RegKey := "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
ValueName := "Scancode Map"
correctMap :=
    "00000000" .
    "00000000" .
    "06000000" .
    "1D003A00" . ;CapsLock ->LCtrl
    "1D005BE0" . ;LWin -> LCtrl
    "3A003800" . ;LAlt -> CapsLock
    "38001D00" . ;LCtrl -> LAlt
    "5BE01DE0" . ;RCtrl -> LWin
    "00000000"

if (RegRead(RegKey, ValueName, "REG_BINARY") != correctMap) {
    RegWrite(correctMap, "REG_BINARY", RegKey, ValueName)
}

;;恢复注册表
; RegDelete("HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout", "Scancode Map")
; MsgBox("已删除所有键位映射。`n请重启电脑生效。", "注册表已恢复", "Iconi")

; ===================== 常驻映射 ====================================
*Browser_Back::F1
*Browser_Refresh::F2
*PrintScreen::F4
SetCapsLockState "AlwaysOff"

; ===================== CapsLock键映射处理 ===========================
CapsLock:: SendEvent "{Esc}"
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
CapsLock & Tab::AltTab
CapsLock & `::Insert
CapsLock & Left::Home
CapsLock & Right::End
CapsLock & Down::PgDn
CapsLock & Enter::^+Esc
CapsLock & BackSpace::Delete
CapsLock & c Up:: CapsState.toggle()
CapsLock & i:: GameSend("{Up}")
CapsLock & k:: GameSend("{Down}")
CapsLock & j:: GameSend("{Left}")
CapsLock & l:: GameSend("{Right}")
CapsLock & o:: GameSend("{Home}")
CapsLock & p:: GameSend("{End}")
CapsLock & [:: GameSend("{PgUp}")
CapsLock & ]:: GameSend("{PgDn}}")
CapsLock & `;:: GameSend("^{Left}")
CapsLock & ':: GameSend("^{Right}")

; ================= CapsLock状态切换 ==============================
class CapsState {
    static state := false
    static toggle() {
        this.state := !this.state
        SetCapsLockState (this.state ? "AlwaysOn" : "AlwaysOff") ; 简化状态设置
    }
}

; ================ 高级游戏发送函数 =================================
GameSend(key) {
    ; 1. 获取当前修饰键状态
    modifiers := ""
    if GetKeyState("Ctrl", "P")
        modifiers .= "^"
    if GetKeyState("Shift", "P")
        modifiers .= "+"
    if GetKeyState("Alt", "P")
        modifiers .= "!"
    if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
        modifiers .= "#"
    ; 2. 构造完整按键序列
    fullKey := modifiers . key
    ; 3. 使用底层SendEvent确保修饰键状态传递
    SendEvent "{Blind}" . fullKey
}