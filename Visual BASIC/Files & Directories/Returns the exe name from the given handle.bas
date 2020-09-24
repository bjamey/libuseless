' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'
'  Title: Returns the .exe name from the given handle
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Public Const TH32CS_SNAPPROCESS As Long = 2&
Public Const MAX_PATH As Long = 260

Public Type PROCESSENTRY32
   dwSize As Long
   cntUsage As Long
   th32ProcessID As Long
   th32DefaultHeapID As Long
   th32ModuleID As Long
   cntThreads As Long
   th32ParentProcessID As Long
   pcPriClassBase As Long
   dwflags As Long
   szexeFile As String * MAX_PATH
End Type

Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hWnd As Long, lpdwProcessId As Long) As Long
Public Declare Function CreateToolhelpSnapshot Lib "Kernel32" Alias "CreateToolhelp32Snapshot" (ByVal lFlgas As Long, ByVal lProcessID As Long) As Long
Public Declare Function ProcessFirst Lib "Kernel32" Alias "Process32First" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Public Declare Function ProcessNext Lib "Kernel32" Alias "Process32Next" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Public Declare Sub CloseHandle Lib "Kernel32" (ByVal hPass As Long)


' ---------
' Code
' ---------

Public Function GetExeFromHandle(hWnd As Long) As String
    Dim threadID As Long, processID As Long, hSnapshot As Long
    Dim uProcess As PROCESSENTRY32, rProcessFound As Long
    Dim i As Integer, szExename As String

    ' Get ID for window thread
    threadID = GetWindowThreadProcessId(hWnd, processID)

    ' Check if valid
    If threadID = 0 Or processID = 0 Then Exit Function

    ' Create snapshot of current processes
    hSnapshot = CreateToolhelpSnapshot(TH32CS_SNAPPROCESS, 0&)

    ' Check if snapshot is valid
    If hSnapshot = -1 Then Exit Function

    ' Initialize uProcess with correct size
    uProcess.dwSize = Len(uProcess)

    'Start looping through processes
    rProcessFound = ProcessFirst(hSnapshot, uProcess)

    Do While rProcessFound
       If uProcess.th32ProcessID = processID Then
          ' Found it, now get name of exefile
          i = InStr(1, uProcess.szexeFile, Chr(0))
          If i > 0 Then szExename = Left$(uProcess.szexeFile, i - 1)

          Exit Do
       Else
           ' Wrong ID, so continue looping
           rProcessFound = ProcessNext(hSnapshot, uProcess)
       End If
    Loop

    Call CloseHandle(hSnapshot)

    GetExeFromHandle = szExename
End Function                                                                
