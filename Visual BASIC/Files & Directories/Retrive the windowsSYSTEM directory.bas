' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrive the windowsSYSTEM directory
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetWindowsSysDir
'
' Calls the windows API to get the windows\SYSTEM directory
' and ensures that a trailing dir separator is present
'
' Returns: The windows\SYSTEM directory
'-----------------------------------------------------------
'
Function GetWindowsSysDir() As String
    Dim strBuf As String

    strBuf = Space$(gintMAX_SIZE)

    '
    'Get the system directory and then trim the buffer to the exact length
    'returned and add a dir sep (backslash) if the API didn't return one
    '
    If GetSystemDirectory(strBuf, gintMAX_SIZE) > 0 Then
        strBuf = StripTerminator(strBuf)
        AddDirSep strBuf

        GetWindowsSysDir = strBuf
    Else
        GetWindowsSysDir = vbNullString
    End If
End Function
