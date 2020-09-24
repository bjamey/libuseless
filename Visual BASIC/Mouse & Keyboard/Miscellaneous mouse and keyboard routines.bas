' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Miscellaneous mouse and keyboard routines
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' MouseKeyboard version 1.1 by Lord Orwell

' ----------------------------
' Constants & API Declarations
' ----------------------------

' this sub contains all of the mouse and keyboard subs.
Public Const KEYEVENTF_KEYUP = &H2
Private Const SPI_SCREENSAVERRUNNING = 97&
Declare Function CharToOem& Lib "user32" Alias "CharToOemA" (ByVal lpszSrc As String, ByVal lpszDst As String)
Declare Function GetAsyncKeyState% Lib "user32" (ByVal vKey As Long)
Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer
'Declare Function GetKeyboardState& Lib "user32" (pbKeyState As String)
Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)
Declare Function MapVirtualKey Lib "user32" Alias "MapVirtualKeyA" (ByVal wCode As Long, ByVal wMapType As Long) As Long
Declare Function OemKeyScan& Lib "user32" (ByVal wOemChar As Integer)
Declare Function ShowCursor Lib "user32" (ByVal bShow As Long) As Long
Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, lpvParam As Any, ByVal fuWinIni As Long) As Long
Declare Function VkKeyScan% Lib "user32" Alias "VkKeyScanA" (ByVal cChar As Byte)


' -----------
' Functions
' -----------

Sub ShowMouseCursor()
    Dim rtn As Long
    rtn = ShowCursor(True)
End Sub

Sub HideMouseCursor()
    Dim rtn As Long
    rtn = ShowCursor(False)
End Sub

Sub DisableTaskKeys()
    'disables ctrl-alt-del, alt-tab, ctrl-f4, etc., keeping you in charge...
    Dim rtn As Long
    rtn = SystemParametersInfo(SPI_SCREENSAVERRUNNING, 1&, 0&, 0)
End Sub

Sub EnableTaskKeys()
    Dim rtn As Long
    rtn = SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0&, 0&, 0)
End Sub

Function ScanCodeToAscii(ScanCode As Long) As Long
    ScanCodeToAscii = MapVirtualKey(ScanCode, 2)
End Function

Function WasKeyPressed(VBKey As Long)
    Dim ScanCode As Integer
    ScanCode = GetKeyState(VBKey)
    If ScanCode And &HFFF0 > 0 Then
        WasKeyPressed = True
    Else
        WasKeyPressed = False
    End If
End Function

Function IsKeyPressed(VBKey As Long) As Boolean
    Dim KeyState As Integer
    KeyState = GetAsyncKeyState(VBKey)

    If KeyState And &H8000 = &H8000 Then
        IsKeyPressed = True     ' : Debug.Print VBKey
    Else
        IsKeyPressed = False
    End If
End Function

Function IsAsciiKeyPressed(Ascii As Integer) As Boolean
    '
End Function

Public Sub TypeAsciiKey(ByVal Char As Integer, AllStates As Integer)
    Dim c As String
    Dim vk%
    Dim Scan%
    Dim OemChar$
'    Dim dl&
    Dim ShiftState As Integer
'    Dim ss As Long
    Dim CtrlState As Integer
    Dim AltState As Integer
    Dim ShiftScanCode As Integer
    Dim CtrlScanCode As Integer
    Dim AltScanCode As Integer
    ShiftScanCode = MapVirtualKey(vbKeyShift, 0)
    CtrlScanCode = MapVirtualKey(vbKeyControl, 0)
    AltScanCode = MapVirtualKey(vbKeyMenu, 0)
    c = ChrW$(Char)
    'ss = (VkKeyScan(AscW(c$)) And &H100) / &HFF
    ' MsgBox ss
    ' Get the virtual key code for this character
    vk% = VkKeyScan(Char) And &HFF
    If AllStates = 0 Then AllStates = (VkKeyScan(AscW(c$)) And &H100) / &HFF
    ShiftState = AllStates And 1
    CtrlState = (AllStates And 2) / 2
    AltState = (AllStates And 4) / 4
    OemChar$ = "  "                                        ' 2 character buffer
    ' Get the OEM character - preinitialize the buffer
    CharToOem left$(c$, 1), OemChar$
    ' Get the scan code for this key
    Scan% = OemKeyScan(AscW(OemChar$)) And &HFF
    If ShiftState = 1 Then
        keybd_event vbKeyShift, ShiftScanCode, 0, 0
        DoEvents
    End If
    If CtrlState = 1 Then
        keybd_event vbKeyControl, CtrlScanCode, 0, 0
        DoEvents
    End If
    If AltState = 1 Then
        keybd_event vbKeyMenu, AltScanCode, 0, 0
        DoEvents
    End If
    ' Send the key down
    keybd_event vk%, Scan%, 0, 0
    DoEvents
    ' Send the key up
    keybd_event vk%, Scan%, KEYEVENTF_KEYUP, 0
    DoEvents
    If ShiftState = 1 Then
        keybd_event vbKeyShift, ShiftScanCode, KEYEVENTF_KEYUP, 0
        DoEvents
    End If
    If CtrlState = 1 Then
        keybd_event vbKeyControl, CtrlScanCode, KEYEVENTF_KEYUP, 0
        DoEvents
    End If
    If AltState = 1 Then
        keybd_event vbKeyMenu, AltScanCode, KEYEVENTF_KEYUP, 0
        DoEvents
    End If
End Sub

Sub TypeKey(KeyToType As String, ToggleKeys As Integer)
    'togglekeys: bit1 = shift, 2 = ctrl, 3 = alt.
    Call TypeAsciiKey(AscW(KeyToType), ToggleKeys)
End Sub

Sub MySendKeys(StringToType As String)
'    MsgBox StringToType
    'doesn't work exactly like the vb version.
    'to send a shifted character, simply type it.
    'it will be converted automatically.  There are
    'three exceptions: ~^%{.  Each of these keys has to
    'be typed 2 times in a row.  They are used to toggle
    'on shift, ctrl, and/or alt states of the keyboard
    'for the next character typed.
    'special codes: + = shift, ^ = ctrl, % = alt
    'a * after the ' means it is implemented, otherwise
    ' it is slated for future implementation
    '*BACKSPACE   {BACKSPACE}, {BS}, or {BKSP}
    '*BREAK   {BREAK}
    '*CAPS LOCK   {CAPSLOCK}
    '*DEL or DELETE   {DELETE} or {DEL}
    '*DOWN ARROW  {DOWN}
    '*END {END}
    '*ENTER   {ENTER}or ~
    '*ESC {ESC}
    ' HELP    {HELP}
    ' HOME    {HOME}
    '*INS or INSERT   {INSERT} or {INS}
    '*LEFT ARROW  {LEFT}
    ' NUM LOCK    {NUMLOCK}
    ' PAGE DOWN   {PGDN}
    ' PAGE UP {PGUP}
    '*PRINT SCREEN    {PRTSC}
    '*RIGHT ARROW {RIGHT}
    ' SCROLL LOCK {SCROLLLOCK}
    '*TAB {TAB}
    '*UP ARROW    {UP}
    ' F1  {F1}
    ' F2  {F2}
    ' F3  {F3}
    ' F4  {F4}
    ' F5  {F5}
    ' F6  {F6}
    ' F7  {F7}
    ' F8  {F8}
    ' F9  {F9}
    ' F10 {F10}
    ' F11 {F11}
    ' F12 {F12}
    ' F13 {F13}
    ' F14 {F14}
    ' F15 {F15}
    ' F16 {F16}
'    Dim LcaseStringToType As String
    Dim ToggleKeys As Integer
    Dim Char As String
    ToggleKeys = 0
    Dim cl As Long
    cl = 1
    Do While cl <= Len(StringToType)
        ToggleKeys = 0
'        LcaseStringToType = LCase$(StringToType)
        Do While Char = "%" Or Char = "^" Or Char = "+" Or Char = "{" Or Char = "~"
            Char = Mid$(StringToType, cl, 1)
            If Char = "{" Then
                cl = cl + 1
                If Mid$(StringToType, cl - 1, 2) = "{{" Then
                    cl = cl + 1
                    Call TypeKey(Char, 0)
                Else
                    If StrComp(Mid$(StringToType, cl, 10), "backspace}", vbTextCompare) = 0 Then
                        cl = cl + 10
                        VirtualKeyPress vbKeyBack
                    ElseIf StrComp(Mid$(StringToType, cl, 3), "bs}", vbTextCompare) = 0 Then
                        cl = cl + 3
                        VirtualKeyPress vbKeyBack
                    ElseIf StrComp(Mid$(StringToType, cl, 5), "bksp}", vbTextCompare) = 0 Then
                        cl = cl + 5
                        VirtualKeyPress vbKeyBack
                    ElseIf StrComp(Mid$(StringToType, cl, 7), "delete}", vbTextCompare) = 0 Then
                        cl = cl + 7
                        VirtualKeyPress vbKeyDelete
                    ElseIf StrComp(Mid$(StringToType, cl, 4), "del}", vbTextCompare) = 0 Then
                        cl = cl + 4
                        VirtualKeyPress vbKeyDelete
                    ElseIf StrComp(Mid$(StringToType, cl, 5), "home}", vbTextCompare) = 0 Then
                        cl = cl + 5
                        VirtualKeyPress vbKeyHome
                    ElseIf StrComp(Mid$(StringToType, cl, 6), "enter}", vbTextCompare) = 0 Then
                        cl = cl + 6
                        VirtualKeyPress vbKeyReturn
                    ElseIf StrComp(Mid$(StringToType, cl, 4), "tab}", vbTextCompare) = 0 Then
                        cl = cl + 4
                        VirtualKeyPress vbKeyTab
                    ElseIf StrComp(Mid$(StringToType, cl, 6), "prtsc}", vbTextCompare) = 0 Then
                        cl = cl + 6
                        VirtualKeyPress vbKeySnapshot
                    ElseIf StrComp(Mid$(StringToType, cl, 4), "end}", vbTextCompare) = 0 Then
                        cl = cl + 4
                        VirtualKeyPress vbKeyEnd
                    ElseIf StrComp(Mid$(StringToType, cl, 4), "ins}", vbTextCompare) = 0 Then
                        cl = cl + 4
                        VirtualKeyPress vbKeyInsert
                    ElseIf StrComp(Mid$(StringToType, cl, 7), "insert}", vbTextCompare) = 0 Then
                        cl = cl + 7
                        VirtualKeyPress vbKeyInsert
                    ElseIf StrComp(Mid$(StringToType, cl, 5), "left}", vbTextCompare) = 0 Then
                        cl = cl + 5
                        VirtualKeyPress vbKeyLeft
                    ElseIf StrComp(Mid$(StringToType, cl, 6), "right}", vbTextCompare) = 0 Then
                        cl = cl + 6
                        VirtualKeyPress vbKeyRight
                    ElseIf StrComp(Mid$(StringToType, cl, 6), "break}", vbTextCompare) = 0 Then
                        cl = cl + 6
                        VirtualKeyPress vbKeyPause
                    ElseIf StrComp(Mid$(StringToType, cl, 9), "capslock}", vbTextCompare) = 0 Then
                        cl = cl + 9
                        VirtualKeyPress vbKeyCapital
                    ElseIf StrComp(Mid$(StringToType, cl, 10), "downarrow}", vbTextCompare) = 0 Then
                        cl = cl + 10
                        VirtualKeyPress vbKeyDown
                    ElseIf StrComp(Mid$(StringToType, cl, 8), "uparrow}", vbTextCompare) = 0 Then
                        cl = cl + 8
                        VirtualKeyPress vbKeyUp
                    ElseIf StrComp(Mid$(StringToType, cl, 4), "esc}", vbTextCompare) = 0 Then
                        cl = cl + 4
                        VirtualKeyPress vbKeyEscape
                    End If
                End If
            ElseIf Char = "~" Then
                cl = cl + 1
                If Mid$(StringToType, cl, 1) = "~" Then
                    cl = cl + 1
                    Call TypeKey(Char, 0)
                Else
                    VirtualKeyPress vbKeyReturn
                End If
            ElseIf Char = "+" Then
                cl = cl + 1
                If Mid$(StringToType, cl, 1) = "+" Then
                    cl = cl + 1
                    Call TypeKey(Char, 0)
                Else
                    ToggleKeys = ToggleKeys + 1
                End If
            ElseIf Char = "^" Then
                cl = cl + 1
                If Mid$(StringToType, cl - 1, 2) = "^^" Then
                    cl = cl + 1
                    Call TypeKey(Char, 0)
                Else
                    ToggleKeys = ToggleKeys + 2
                End If
            ElseIf Char = "%" Then
                cl = cl + 1
                If Mid$(StringToType, cl - 1, 2) = "%%" Then
                    cl = cl + 1
                    Call TypeKey(Char, 0)
                Else
                    ToggleKeys = ToggleKeys + 4
                End If
            End If
        Loop
'        Debug.Print Char, ToggleKeys
        If Len(Char) <> 0 Then Call TypeKey(Char, ToggleKeys)
    Loop
End Sub

Sub VirtualKeyPress(VirtualKeyCode As Integer)
    Dim ScanCode As Integer
    ScanCode = MapVirtualKey(VirtualKeyCode, 0)
    keybd_event VirtualKeyCode%, ScanCode, 0, 0
    DoEvents
    keybd_event VirtualKeyCode, ScanCode, KEYEVENTF_KEYUP, 0
    DoEvents
End Sub

Public Sub VirtualKeyPressEx(VirtualKeyCode As Integer, Shift As Integer, Ctrl As Integer, Alt As Integer)
    Dim ShiftScanCode As Integer
    Dim CtrlScanCode As Integer
    Dim AltScanCode As Integer

    ShiftScanCode = MapVirtualKey(vbKeyShift, 0)
    CtrlScanCode = MapVirtualKey(vbKeyControl, 0)
    AltScanCode = MapVirtualKey(vbKeyMenu, 0)

    ' Get the virtual key code for this character
    Dim ScanCode As Integer
    ScanCode = MapVirtualKey(VirtualKeyCode, 0)

'    Shift = AllStates And 1
'    Ctrl = (AllStates And 2) / 2
'    Alt = (AllStates And 4) / 4

    If Ctrl = 1 Then
        keybd_event vbKeyControl, CtrlScanCode, 0, 0
        DoEvents
    End If
    If Shift = 1 Then
        keybd_event vbKeyShift, ShiftScanCode, 0, 0
        DoEvents
    End If
    If Alt = 1 Then
        keybd_event vbKeyMenu, AltScanCode, 0, 0
        DoEvents
    End If

    ' Send the key down
    keybd_event VirtualKeyCode%, ScanCode, 0, 0
    DoEvents
    ' Send the key up
    keybd_event VirtualKeyCode, ScanCode, KEYEVENTF_KEYUP, 0
    DoEvents

    If Shift = 1 Then
        keybd_event vbKeyShift, ShiftScanCode, KEYEVENTF_KEYUP, 0
        DoEvents
    End If
    If Ctrl = 1 Then
        keybd_event vbKeyControl, CtrlScanCode, KEYEVENTF_KEYUP, 0
        DoEvents
    End If
    If Alt = 1 Then
        keybd_event vbKeyMenu, AltScanCode, KEYEVENTF_KEYUP, 0
        DoEvents
    End If
End Sub
