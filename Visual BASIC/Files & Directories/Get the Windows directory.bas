' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get the Windows directory
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetWindowsDir
'
' Calls the windows API to get the windows directory and
' ensures that a trailing dir separator is present
'
' Returns: The windows directory
'-----------------------------------------------------------
'
Function GetWindowsDir() As String
    Dim strBuf As String

    strBuf = Space$(gintMAX_SIZE)

    '
    'Get the windows directory and then trim the buffer to the exact length
    'returned and add a dir sep (backslash) if the API didn't return one
    '
    If GetWindowsDirectory(strBuf, gintMAX_SIZE) > 0 Then
        strBuf = StripTerminator$(strBuf)
        AddDirSep strBuf

        GetWindowsDir = strBuf
    Else
        GetWindowsDir = vbNullString
    End If
End Function
