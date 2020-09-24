' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get the Application Path with - without the Filename
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Get the Application Path WITHOUT the Filename
Dim appPath As String = System.Windows.Forms.Application.StartupPath

' Get the Application Path with the Filename
Dim appPathFilename As String = System.Windows.Forms.Application.ExecutablePath
