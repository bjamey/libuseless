' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Shell out to a 32-bit application and wait until task completes
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Declarations

'*** Monitoring a DOS Shell
Private Declare Function OpenProcess Lib "Kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function GetExitCodeProcess Lib "Kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Private Declare Sub Sleep Lib "Kernel32" (ByVal dwMilliseconds As Long)
Const STILL_ACTIVE = &H103
Const PROCESS_QUERY_INFORMATION = &H400


' Code


Sub Shell32Bit(ByVal JobToDo As String)

         Dim hProcess As Long
         Dim RetVal As Long
         'The next line launches JobToDo as icon,

         'captures process ID
         hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, False, Shell(JobToDo, 1))

         Do

             'Get the status of the process
             GetExitCodeProcess hProcess, RetVal

             'Sleep command recommended as well as DoEvents
             DoEvents: Sleep 100

         'Loop while the process is active
         Loop While RetVal = STILL_ACTIVE


End Sub
