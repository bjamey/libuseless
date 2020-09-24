' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'
'  Title: Perform various file operations (like Windows File Explorer) and show
'         progress dialog and  or error dialogs
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

  ' ----------------------------
' Constants & API Declarations
' ----------------------------

'Place the following code in a Module

Public Const FO_MOVE As Long = &H1                       ' Move File
Public Const FO_COPY As Long = &H2                       ' Copy File
Public Const FO_DELETE As Long = &H3                     ' Delete File
Public Const FO_RENAME As Long = &H4                     ' Rename File
Public Const FOF_MULTIDESTFILES As Long = &H1
Public Const FOF_CONFIRMMOUSE As Long = &H2
Public Const FOF_SILENT As Long = &H4
Public Const FOF_RENAMEONCOLLISION As Long = &H8
Public Const FOF_NOCONFIRMATION As Long = &H10
Public Const FOF_WANTMAPPINGHANDLE As Long = &H20
Public Const FOF_CREATEPROGRESSDLG As Long =&H0          ' Use Progress Dialog
Public Const FOF_ALLOWUNDO As Long = &H40
Public Const FOF_FILESONLY As Long = &H80
Public Const FOF_SIMPLEPROGRESS As Long = &H100
Public Const FOF_NOCONFIRMMKDIR As Long = &H200
                                              
Type SHFILEOPSTRUCT
     hwnd As Long
     wFunc As Long
     pFrom As String
     pTo As String
     fFlags As Long
     fAnyOperationsAborted As Long
     hNameMappings As Long
     lpszProgressTitle As String
End Type

Declare Function SHFileOperation Lib "Shell32.dll" Alias "SHFileOperationA" (lpFileOp As SHFILEOPSTRUCT) As Long


' ----------
' Function
' ----------

Sub FileExplorer()
    Dim Result As Long, fileop As SHFILEOPSTRUCT

    With fileop
        .hwnd = Me.hwnd
        .wFunc = FO_COPY
        .pFrom = "C:\PROGRAM FILES\MICROSOFT VISUAL BASIC\VB.HLP" & vbNullChar & "C:\PROGRAM FILES\MICROSOFT VISUAL BASIC\README.HLP" & vbNullChar & vbNullChar
        .pFrom = "C:\*.*" & vbNullChar & vbNullChar
        .pTo = "C:\testfolder" & vbNullChar & vbNullChar
        .fFlags = FOF_SIMPLEPROGRESS Or FOF_FILESONLY
    End With

    Result = SHFileOperation(fileop)
    If Result <> 0 Then
        ' Operation failed
        MsgBox Err.LastDllError
    Else
        If fileop.fAnyOperationsAborted <> 0 Then
           MsgBox "Operation Failed"
        End If
    End If
End Sub
