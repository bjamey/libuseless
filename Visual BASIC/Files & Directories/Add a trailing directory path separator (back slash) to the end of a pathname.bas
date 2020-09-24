' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Add a trailing directory path separator (back slash) to the end of a
'         pathname unless one already exists
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' SUB: AddDirSep
' Add a trailing directory path separator (back slash) to the
' end of a pathname unless one already exists
'
' IN/OUT: [strPathName] - path to add separator to
'-----------------------------------------------------------
'
Sub AddDirSep(strPathName As String)
    If Right(Trim(strPathName), Len(gstrSEP_URLDIR)) <> gstrSEP_URLDIR And _
       Right(Trim(strPathName), Len(gstrSEP_DIR)) <> gstrSEP_DIR Then
        strPathName = RTrim$(strPathName) & gstrSEP_DIR
    End If
End Sub                                         
