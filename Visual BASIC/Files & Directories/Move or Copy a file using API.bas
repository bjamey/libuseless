' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Move  Copy a file using API
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

 ' ----------------------------
' Constants & API Declaration
' ----------------------------

Private Declare Function CopyFile Lib "kernel32" Alias "CopyFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String, ByVal bFailIfExists As Long) As Long
Private Declare Function MoveFile Lib "kernel32" Alias "MoveFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String) As Long


' ----------
' Functions
' ----------

Sub Copy_File(Source As String, Target As String)
    'Copy File

    Dim l As Long

    l = CopyFile(Trim$(Source), Trim$(Target), False)
    If l Then
        ' File copied!
    Else
        ' Error. File not moved!
    End If
End Sub

' ================================================== '

Sub Move_File(Source As String, Target As String)
    Dim l As Long

    l = MoveFile(Trim$(Source), Trim$(Target))

    If l Then
        ' File moved!
    Else
        ' Error. File not moved!
    End If
End Sub             
