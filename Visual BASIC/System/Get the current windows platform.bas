' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get the current windows platform
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'----------------------------------------------------------
' FUNCTION: GetWinPlatform
' Get the current windows platform.
' ---------------------------------------------------------
Public Function GetWinPlatform() As Long
    Dim osvi As OSVERSIONINFO
    Dim strCSDVersion As String

    osvi.dwOSVersionInfoSize = Len(osvi)

    If GetVersionEx(osvi) = 0 Then
        Exit Function
    End If

    GetWinPlatform = osvi.dwPlatformId
End Function
