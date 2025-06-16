; ==============================================================
; 键盘映射工具 v3.9.0
; 功能：Win/CapsLock 切换映射模式
; 注册表改键主要是适配Chrome OS键盘(无CapsLk键)
; ==============================================================
#Requires AutoHotkey v2.0
#InputLevel 1  ; 提升输入优先级
#SingleInstance Force
InstallKeybdHook
Persistent
#Warn All
SetWorkingDir A_ScriptDir

; ===================== 性能优化配置 =============================
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
DetectHiddenWindows true
for process in ComObject("WbemScripting.SWbemLocator").ConnectServer().ExecQuery("Select * from Win32_Process where Name like 'AutoHotkey%'") {
    if (process.ProcessId != ProcessExist()) { 
        try {
            ProcessClose process.ProcessId
        }
    }
}
DetectHiddenWindows false

; ===================== 常驻映射 ====================================
*Browser_Back::F1
*Browser_Refresh::F2
*PrintScreen::F4
*RAlt::RCtrl
*RCtrl::RAlt
*`::`
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
CapsLock & Tab::#Tab
CapsLock & `::Insert
CapsLock & Left::Home
CapsLock & Right::End
CapsLock & Down::PgDn
CapsLock & Enter::^+Esc
CapsLock & BackSpace::Delete
CapsLock & c Up:: CapsState.toggle()
CapsLock & i:: SendEvent "{Blind}{Up}"
CapsLock & k:: SendEvent "{Blind}{Down}"
CapsLock & j:: SendEvent "{Blind}{Left}"
CapsLock & l:: SendEvent "{Blind}{Right}"
CapsLock & o:: SendEvent "{Blind}{Home}"
CapsLock & p:: SendEvent "{Blind}{End}"
CapsLock & [:: SendEvent "{Blind}{PgUp}"
CapsLock & ]:: SendEvent "{Blind}{PgDn}}"
CapsLock & `;:: SendEvent "{Blind}^{Left}"
CapsLock & ':: SendEvent "{Blind}^{Right}"

; ===================== 亮度声音控制 ===================================
` & +:: Run("powershell.exe (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness"
    . "(1, (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightness).CurrentBrightness + 10)", , "Hide")
` & -:: Run("powershell.exe (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness"
    . "(1, (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightness).CurrentBrightness - 10)", , "Hide")
` & 9:: Send("{Volume_Down}")
` & 0:: Send("{Volume_Up}")
` & 8:: Send "{Volume_Mute}"

; ================= CapsLock状态切换 ==================================
class CapsState {
    static state := false
    static toggle() {
        this.state := !this.state
        SetCapsLockState (this.state ? "AlwaysOn" : "AlwaysOff")
    }
}