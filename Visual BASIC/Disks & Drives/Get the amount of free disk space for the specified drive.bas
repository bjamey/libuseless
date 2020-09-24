' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get the amount of free disk space for the specified drive
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetDiskSpaceFree
' Get the amount of free disk space for the specified drive
'
' IN: [strDrive] - drive to check space for
'
' Returns: Amount of free disk space, or -1 if an error occurs
'-----------------------------------------------------------
'
Function GetDiskSpaceFree(ByVal strDrive As String) As Long
    Dim strCurDrive As String
    Dim lDiskFree As Long

    On Error Resume Next

    '
    'Save the current drive
    '
    strCurDrive = Left$(CurDir$, 2)

    '
    'Fixup drive so it includes only a drive letter and a colon
    '
    If InStr(strDrive, gstrSEP_DRIVE) = 0 Or Len(strDrive) > 2 Then
        strDrive = Left$(strDrive, 1) & gstrSEP_DRIVE
    End If

    '
    'Change to the drive we want to check space for.  The DiskSpaceFree() API
    'works on the current drive only.
    '
    ChDrive strDrive

    '
    'If we couldn't change to the request drive, it's an error, otherwise return
    'the amount of disk space free
    '
    If Err <> 0 Or (strDrive <> Left$(CurDir$, 2)) Then
        lDiskFree = -1
    Else
        Dim lRet As Long
        Dim lBytes As Long, lSect As Long, lClust As Long, lTot As Long

        lRet = GetDiskFreeSpace(vbNullString, lSect, lBytes, lClust, lTot)
        On Error Resume Next
        lDiskFree = (lBytes * lSect) * lClust
        If Err Then lDiskFree = 2147483647
    End If

    If lDiskFree = -1 Then
        MsgError Error$ & vbLf & vbLf & ResolveResString(resDISKSPCERR) & strDrive, vbExclamation, gstrTitle
    End If

    GetDiskSpaceFree = lDiskFree

    '
    'Cleanup by setting the current drive back to the original
    '
    ChDrive strCurDrive

    Err = 0
End Function
