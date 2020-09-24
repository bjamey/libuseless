' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Open - Save File using API
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

' File I/O
Const FILE_BEGIN As Long = 0
Const FILE_SHARE_READ As Long = &H1
Const FILE_SHARE_WRITE As Long = &H2
Const OPEN_EXISTING As Long = 3
Const OPEN_ALWAYS As Long = 4
Const GENERIC_READ As Long = &H80000000
Const GENERIC_WRITE As Long = &H40000000

Private Declare Function ReadFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToRead As Long, lpNumberOfBytesRead As Long, ByVal lpOverlapped As Any) As Long
Private Declare Function WriteFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToWrite As Long, lpNumberOfBytesWritten As Long, ByVal lpOverlapped As Any) As Long

Private Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Any, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Declare Function SetFilePointer Lib "kernel32" (ByVal hFile As Long, ByVal lDistanceToMove As Long, lpDistanceToMoveHigh As Long, ByVal dwMoveMethod As Long) As Long
Private Declare Function GetFileSize Lib "kernel32" (ByVal hFile As Long, lpFileSizeHigh As Long) As Long
Private Declare Function SetEndOfFile Lib "kernel32" (ByVal hFile As Long) As Long


' -----------
' Functions
' -----------


Public Function OpenFile(FileName As String) As String
    Dim hFile As Long, l As Long, Result As Long
    Dim sText As String

    '///////////////////////////////////////////////////'
    hFile = CreateFile(FileName, GENERIC_READ, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)

    l = GetFileSize(hFile, 0)
    SetFilePointer hFile, 0, 0, FILE_BEGIN

    sText = Space$(l)
    ReadFile hFile, ByVal sText, l, Result, ByVal 0&

    If Result <> l Then MsgBox "Error reading file ...", vbCritical: Exit Function

    CloseHandle hFile
    '///////////////////////////////////////////////////'

    OpenFile = sText
End Function

Public Sub SaveFile(FileName As String, sText As String)
    Dim hFile As Long, Result As Long

    '///////////////////////////////////////////////////'
    ' get a handle for the file
    hFile = CreateFile(FileName, GENERIC_WRITE, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_ALWAYS, 0, 0)
'    hFile = CreateFile(FileName, GENERIC_WRITE, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)

    SetFilePointer hFile, 0, 0, FILE_BEGIN

    ' write data
    '=========================================='
    WriteFile hFile, ByVal sText, Len(sText), Result, ByVal 0&
    '=========================================='

    ' important: truncate file at current position
    SetEndOfFile hFile

    ' close file handle
    CloseHandle hFile
    '///////////////////////////////////////////////////'
End Sub
