; ==============================================================
; 键盘映射工具 v3.9.9
; 功能：Win/CapsLock 切换映射模式
; ==============================================================
#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
InstallKeybdHook
ProcessSetPriority "High"
A_MenuMaskKey := "vkE8"
Thread "Interrupt", 0
A_HotkeyInterval := 50
A_MaxHotkeysPerInterval := 200

; ===================== 系统初始化 =================================
startupLink := A_Startup "\AHK.lnk"
if !FileExist(startupLink)
    FileCreateShortcut(A_ScriptFullPath, startupLink)
RegKey := "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
ValueName := "Scancode Map"
correctMap :=
    "00000000" .
    "00000000" .
    "02000000" .
    "3A005BE0" . ;LWin -> CapsLock
    "00000000"
if (RegRead(RegKey, ValueName, "REG_BINARY") != correctMap) {
    RegWrite(correctMap, "REG_BINARY", RegKey, ValueName)
}
; RegDelete("HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout", "Scancode Map")

; ===================== 常驻映射 ====================================
*Browser_Back::F1
*Browser_Refresh::F2
*PrintScreen::F4
*RAlt::LWin
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
CapsLock & c::CapsLock
CapsLock & Enter::^+Esc
CapsLock & BackSpace::Delete
CapsLock & L::
{
    KeyWait("L")
    KeyWait("CapsLock")
    DllCall("LockWorkStation")
}