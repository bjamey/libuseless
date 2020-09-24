' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Detect Windows NT
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: IsWindowsNT
'
' Returns true if this program is running under Windows NT
'-----------------------------------------------------------
'
Function IsWindowsNT() As Boolean
    Const dwMaskNT = &H2&
    IsWindowsNT = (GetWinPlatform() And dwMaskNT)
End Function


'-----------------------------------------------------------
' FUNCTION: IsWindowsNT4WithoutSP2
'
' Determines if the user is running under Windows NT 4.0
' but without Service Pack 2 (SP2).  If running under any
' other platform, returns False.
'
' IN: [none]
'
' Returns: True if and only if running under Windows NT 4.0
' without at least Service Pack 2 installed.
'-----------------------------------------------------------
'
Function IsWindowsNT4WithoutSP2() As Boolean
    IsWindowsNT4WithoutSP2 = False

    If Not IsWindowsNT() Then
        Exit Function
    End If

    Dim osvi As OSVERSIONINFO
    Dim strCSDVersion As String
    osvi.dwOSVersionInfoSize = Len(osvi)
    If GetVersionEx(osvi) = 0 Then
        Exit Function
    End If
    strCSDVersion = StripTerminator(osvi.szCSDVersion)

    'Is this Windows NT 4.0?
    Const NT4MajorVersion = 4
    Const NT4MinorVersion = 0
    If (osvi.dwMajorVersion <> NT4MajorVersion) Or (osvi.dwMinorVersion <> NT4MinorVersion) Then
        'No.  Return False.
        Exit Function
    End If

    'If no service pack is installed, or if Service Pack 1 is
    'installed, then return True.
    Const strSP1 = "SERVICE PACK 1"
    If strCSDVersion = "" Then
        IsWindowsNT4WithoutSP2 = True 'No service pack installed
    ElseIf strCSDVersion = strSP1 Then
        IsWindowsNT4WithoutSP2 = True 'Only SP1 installed
    End If
End Function
