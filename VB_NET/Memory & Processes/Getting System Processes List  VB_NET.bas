' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Getting System Processes List  VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Dim sProcesses() As System.Diagnostics.Process
Dim sProcess As System.Diagnostics.Process
Dim s As String

On Error Goto ErrorHandler

sProcesses = System.Diagnostics.Process.GetProcesses()
s = ""
s = vbCrLf & "Procss Info " & vbCrLf

For Each sProcess In sProcesses
    s = s & sProcess.Id & Space(5) & sProcess.ProcessName() & vbCrLf
Next

txtProcesses.Text = s

ErrorHandler:
MsgBox "Unexpected Error occurred"

' System.Diagnostics.Process is NameSpace provides the method GetProcesses() to get the list of process running in your system. This function returns  Object array  of type Process. The ID and ProcessName properties of the Process object can be used to retrive the ProcessID(PID) and the Name process.

' The overloaded function GetProcesses with << System Name >> parameter can be invoked to get list of processes running in a remote system.
