' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Various Keyboard routines
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'--------- Class Name: clsKeys

Option Explicit

Private Declare Function MapVirtualKey Lib "user32" Alias _
   "MapVirtualKeyA" (ByVal wCode As Long, _
   ByVal wMapType As Long) As Long

Private Declare Function VkKeyScan Lib "user32" Alias "VkKeyScanA" (ByVal _
   cChar As Byte) As Integer

Private Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal _
   bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As _
   Long) As Integer

Private Const KEYEVENTF_EXTENDEDKEY = &H1
Private Const KEYEVENTF_KEYUP = &H2

Public Enum EnumKeys
    keyBackspace = &H8
    keyTab = &H9
    keyReturn = &HD
    keyShift = &H10
    keyControl = &H11
    keyAlt = &H12
    keyPause = &H13
    keyEscape = &H1B
    keySpace = &H20
    keyEnd = &H23                                   
    keyHome = &H24
    keyLeft = &H25
    KeyUp = &H26
    keyRight = &H27
    KeyDown = &H28
    keyInsert = &H2D
    keyDelete = &H2E
    keyF1 = &H70
    keyF2 = &H71
    keyF3 = &H72
    keyF4 = &H73
    keyF5 = &H74
    keyF6 = &H75
    keyF7 = &H76
    keyF8 = &H77
    keyF9 = &H78
    keyF10 = &H79
    keyF11 = &H7A
    keyF12 = &H7B
    keyNumLock = &H90
    keyScrollLock = &H91
    keyCapsLock = &H14
End Enum

'Presses the single key represented by sKey
Public Sub PressKey(sKey As String, Optional bHold As Boolean, Optional _
   bRelease As Boolean)

    Dim nVK As Long
    nVK = VkKeyScan(Asc(sKey))

    If nVK = 0 Then
        Exit Sub
    End If

    Dim nScan As Long
    Dim nExtended As Long

    nScan = MapVirtualKey(nVK, 2)
    nExtended = 0
    If nScan = 0 Then
        nExtended = KEYEVENTF_EXTENDEDKEY
    End If
    nScan = MapVirtualKey(nVK, 0)

    Dim bShift As Boolean
    Dim bCtrl As Boolean
    Dim bAlt As Boolean

    bShift = (nVK And &H100)
    bCtrl = (nVK And &H200)
    bAlt = (nVK And &H400)

    nVK = (nVK And &HFF)

    If Not bRelease Then
        If bShift Then
            keybd_event EnumKeys.keyShift, 0, 0, 0
        End If
        If bCtrl Then
            keybd_event EnumKeys.keyControl, 0, 0, 0
        End If
        If bAlt Then
            keybd_event EnumKeys.keyAlt, 0, 0, 0
        End If

        keybd_event nVK, nScan, nExtended, 0
    End If

    If Not bHold Then
        keybd_event nVK, nScan, KEYEVENTF_KEYUP Or nExtended, 0

        If bShift Then
            keybd_event EnumKeys.keyShift, 0, KEYEVENTF_KEYUP, 0
        End If
        If bCtrl Then
            keybd_event EnumKeys.keyControl, 0, KEYEVENTF_KEYUP, 0
        End If
        If bAlt Then
            keybd_event EnumKeys.keyAlt, 0, KEYEVENTF_KEYUP, 0
        End If
    End If

End Sub

'Loop through a string and calls PressKey for each character (Does not
' parse strings like SendKeys)
Public Sub PressString(ByVal sString As String, Optional bDoEvents As Boolean = True)
    Do While sString <> ""
        PressKey Mid(sString, 1, 1)

        Sleep 20
        If bDoEvents Then
            DoEvents
        End If

        sString = Mid(sString, 2)
    Loop
End Sub

'Presses a specific key (this is used for keys that don't have a
' ascii equilivant)
Public Sub PressKeyVK(keyPress As EnumKeys, Optional bHold As Boolean, _
   Optional bRelease As Boolean, Optional bCompatible As Boolean)

    Dim nScan As Long
    Dim nExtended As Long

    nScan = MapVirtualKey(keyPress, 2)
    nExtended = 0
    If nScan = 0 Then
        nExtended = KEYEVENTF_EXTENDEDKEY
    End If
    nScan = MapVirtualKey(keyPress, 0)

    If bCompatible Then
        nExtended = 0
    End If

    If Not bRelease Then
        keybd_event keyPress, nScan, nExtended, 0
    End If

    If Not bHold Then
        keybd_event keyPress, nScan, KEYEVENTF_KEYUP Or nExtended, 0
    End If

End Sub

'Returns (in the boolean variables) the status of the various Lock keys
Public Sub GetLockStatus(bCapsLock As Boolean, bNumLock As Boolean, _
   bScrollLock As Boolean)

    bCapsLock = GetKeyState(EnumKeys.keyCapsLock)
    bNumLock = GetKeyState(EnumKeys.keyNumLock)
    bScrollLock = GetKeyState(EnumKeys.keyScrollLock)
End Sub
