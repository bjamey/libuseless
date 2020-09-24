' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Verify that the length of the filename strFilename is valid under NT
'         (Intel) and Win95
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

 Public Function fCheckFNLength(strFilename As String) As Boolean
'
' This routine verifies that the length of the filename strFilename is valid.
' Under NT (Intel) and Win95 it can be up to 259 (gintMAX_PATH_LEN-1) characters
' long.  This length must include the drive, path, filename, commandline
' arguments and quotes (if the string is quoted).
'
    fCheckFNLength = (Len(strFilename) < gintMAX_PATH_LEN)
End Function
