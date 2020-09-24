' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Launch Application (with advanced parameters)
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Public Function SyncShell(CommandLine As String, Optional Timeout As Long, _
    Optional WaitForInputIdle As Boolean, Optional Hide As Boolean = False) As Boolean

    Dim hProcess As Long

    Const STARTF_USESHOWWINDOW As Long = &H1
    Const SW_HIDE As Long = 0

    Dim ret As Long
    Dim nMilliseconds As Long

    If Timeout > 0 Then
        nMilliseconds = Timeout
    Else
        nMilliseconds = INFINITE
    End If

    hProcess = StartProcess(CommandLine, Hide)

    If WaitForInputIdle Then
        'Wait for the shelled application to finish setting up its UI:
        ret = InputIdle(hProcess, nMilliseconds)
    Else
        'Wait for the shelled application to terminate:
        ret = WaitForSingleObject(hProcess, nMilliseconds)
    End If

    CloseHandle hProcess

    'Return True if the application finished. Otherwise it timed out or erred.
    SyncShell = (ret = WAIT_OBJECT_0)
End Function
