' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Given a fully qualified filename, returns the path portion and the
'         file portion
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'Given a fully qualified filename, returns the path portion and the file
'   portion.
Public Sub SeparatePathAndFileName(FullPath As String, _
    Optional ByRef Path As String, _
    Optional ByRef FileName As String)

    Dim nSepPos As Long
    Dim sSEP As String

    nSepPos = Len(FullPath)
    sSEP = Mid$(FullPath, nSepPos, 1)
    Do Until IsSeparator(sSEP)
        nSepPos = nSepPos - 1
        If nSepPos = 0 Then Exit Do
        sSEP = Mid$(FullPath, nSepPos, 1)
    Loop

    Select Case nSepPos
        Case Len(FullPath)
            'Separator was found at the end of the full path. This is invalid.
        Case 0
            'Separator was not found.
            Path = CurDir$
            FileName = FullPath
        Case Else
            Path = Left$(FullPath, nSepPos - 1)
            FileName = Mid$(FullPath, nSepPos + 1)
    End Select
End Sub                                  
