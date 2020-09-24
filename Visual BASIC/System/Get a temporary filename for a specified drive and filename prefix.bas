' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get a temporary filename for a specified drive and filename prefix
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetTempFilename
' Get a temporary filename for a specified drive and
' filename prefix
' PARAMETERS:
'   strDestPath - Location where temporary file will be created.  If this
'                 is an empty string, then the location specified by the
'                 tmp or temp environment variable is used.
'   lpPrefixString - First three characters of this string will be part of
'                    temporary file name returned.
'   wUnique - Set to 0 to create unique filename.  Can also set to integer,
'             in which case temp file name is returned with that integer
'             as part of the name.
'   lpTempFilename - Temporary file name is returned as this variable.
' RETURN:
'   True if function succeeds; false otherwise
'-----------------------------------------------------------
'
Function GetTempFilename(ByVal strDestPath As String, ByVal lpPrefixString As String, ByVal wUnique As Integer, lpTempFilename As String) As Boolean
    If strDestPath = vbNullString Then
        '
        ' No destination was specified, use the temp directory.
        '
        strDestPath = String(gintMAX_PATH_LEN, vbNullChar)
        If GetTempPath(gintMAX_PATH_LEN, strDestPath) = 0 Then
            GetTempFilename = False
            Exit Function
        End If
    End If
    lpTempFilename = String(gintMAX_PATH_LEN, vbNullChar)
    GetTempFilename = GetTempFilename32(strDestPath, lpPrefixString, wUnique, lpTempFilename) > 0
    lpTempFilename = StripTerminator(lpTempFilename)
End Function
