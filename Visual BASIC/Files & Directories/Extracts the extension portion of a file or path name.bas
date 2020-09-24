' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Extracts the extension portion of a file or path name
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: Extension
'
' Extracts the extension portion of a file/path name
'
' IN: [strFilename] - file/path to get the extension of
'
' Returns: The extension if one exists, else vbnullstring
'-----------------------------------------------------------
'
Function Extension(ByVal strFilename As String) As String
    Dim intPos As Integer

    Extension = vbNullString

    intPos = Len(strFilename)

    Do While intPos > 0
        Select Case Mid$(strFilename, intPos, 1)
            Case gstrSEP_EXT
                Extension = Mid$(strFilename, intPos + 1)
                Exit Do
            Case gstrSEP_DIR, gstrSEP_DIRALT
                Exit Do
            'End Case
        End Select

        intPos = intPos - 1
    Loop
End Function
