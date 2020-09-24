' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Determines whether the specified file exists
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: FileExists
' Determines whether the specified file exists
'
' IN: [strPathName] - file to check for
'
' Returns: True if file exists, False otherwise
'-----------------------------------------------------------
'
Function FileExists(ByVal strPathName As String) As Integer
    Dim intFileNum As Integer

    On Error Resume Next

    ' If the string is quoted, remove the quotes.
    strPathName = strUnQuoteString(strPathName)

    'Remove any trailing directory separator character
    If Right$(strPathName, 1) = gstrSEP_DIR Then
        strPathName = Left$(strPathName, Len(strPathName) - 1)
    End If

    'Attempt to open the file, return value of this function is False
    'if an error occurs on open, True otherwise
    intFileNum = FreeFile
    Open strPathName For Input As intFileNum
    FileExists = IIf(Err = 0, True, False)
    Close intFileNum

    Err = 0
End Function
