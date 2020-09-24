' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Determines whether the specified directory name exist
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: DirExists
'
' Determines whether the specified directory name exists.
' This function is used (for example) to determine whether
' an installation floppy is in the drive by passing in
' something like 'A:\'.
'
' IN: [strDirName] - name of directory to check for
'
' Returns: True if the directory exists, False otherwise
'-----------------------------------------------------------
'
Public Function DirExists(ByVal strDirName As String) As Integer
    Const strWILDCARD$ = "*.*"

    Dim strDummy As String

    On Error Resume Next

    AddDirSep strDirName
    strDummy = Dir$(strDirName & strWILDCARD, vbDirectory)
    DirExists = Not (strDummy = vbNullString)

    Err = 0
End Function
