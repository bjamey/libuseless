' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Determine whether a disk is fixed, removable, etc
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetDriveType
' Determine whether a disk is fixed, removable, etc. by
' calling Windows GetDriveType()
'-----------------------------------------------------------
'
Function GetDriveType(ByVal intDriveNum As Integer) As Integer
    '
    ' This function expects an integer drive number in Win16 or a string in Win32
    '
    Dim strDriveName As String

    strDriveName = Chr$(Asc("A") + intDriveNum) & gstrSEP_DRIVE & gstrSEP_DIR
    GetDriveType = CInt(GetDriveType32(strDriveName))
End Function
