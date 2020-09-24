' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Try to convert a path to its long filename equivalent, but leave it
'         unaltered if we fail
'
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'Try to convert a path to its long filename equivalent, but leave it unaltered
'   if we fail.
Public Sub MakeLongPath(Path As String)
    On Error Resume Next
    Path = LongPath(Path)
End Sub

Public Function LongPath(Path As String) As String
    Dim oDesktop As IVBShellFolder
    Dim nEaten As Long
    Dim pIdl As Long
    Dim sPath As String
    Dim oMalloc As IVBMalloc

    If Len(Path) > 0 Then
        SHGetDesktopFolder oDesktop
        oDesktop.ParseDisplayName 0, 0, Path, nEaten, pIdl, 0
        sPath = String$(gintMAX_PATH_LEN, 0)
        SHGetPathFromIDListA pIdl, sPath
        SHGetMalloc oMalloc
        oMalloc.Free pIdl
        LongPath = StringFromBuffer(sPath)
    End If
End Function     
