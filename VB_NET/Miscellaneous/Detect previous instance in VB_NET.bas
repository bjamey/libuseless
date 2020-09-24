' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Detect previous instance in VB·NET
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' This uses the Process class to check for the name of the
' current applications process and see whether or not there
' are 'more than 1x instance loaded.
'
' This code is similar to Visual Basic 6.0's App.Previnstance

Dim AppName As String = Process.GetCurrentProcess.ProcessName
Dim sameProcessTotal As Integer = Process.GetProcessesByName(AppName).Length

If sameProcessTotal > 1 Then
   MessageBox.Show("A previous instance of this application is already open!", " App.PreInstance Detected!", _
              MessageBoxButtons.OK, MessageBoxIcon.Information)

   Me.Close()
End If

AppName = Nothing
sameProcessTotal = Nothing
