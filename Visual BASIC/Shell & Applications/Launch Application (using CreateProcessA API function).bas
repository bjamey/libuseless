' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Launch Application (using CreateProcessA API function)
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Public Function StartProcess(CommandLine As String, Optional Hide As Boolean = False) As Long
    Const STARTF_USESHOWWINDOW As Long = &H1
    Const SW_HIDE As Long = 0

    Dim proc As PROCESS_INFORMATION
    Dim Start As STARTUPINFO

    'Initialize the STARTUPINFO structure:
    Start.cb = Len(Start)
    If Hide Then
        Start.dwFlags = STARTF_USESHOWWINDOW
        Start.wShowWindow = SW_HIDE
    End If

    'Start the shelled application:
    CreateProcessA 0&, CommandLine, 0&, 0&, 1&, _
        NORMAL_PRIORITY_CLASS, 0&, 0&, Start, proc

    StartProcess = proc.hProcess
End Function
