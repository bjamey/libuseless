' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Add a trailing URL path separator (forward slash) to the end of a URL
'         unless one (or a back slash) already exists
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

 '-----------------------------------------------------------
' SUB: AddURLDirSep
' Add a trailing URL path separator (forward slash) to the
' end of a URL unless one (or a back slash) already exists
'
' IN/OUT: [strPathName] - path to add separator to
'-----------------------------------------------------------
'
Sub AddURLDirSep(strPathName As String)
    If Right(Trim(strPathName), Len(gstrSEP_URLDIR)) <> gstrSEP_URLDIR And _
       Right(Trim(strPathName), Len(gstrSEP_DIR)) <> gstrSEP_DIR Then
        strPathName = Trim(strPathName) & gstrSEP_URLDIR
    End If
End Sub                                           
