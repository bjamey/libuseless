' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Launch Windows Modem Properties Dialog
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' -------
' Code
' -------

Sub ModemDialog()
    ' Launch Windows Modem Properties Dialog

    Dim dblReturn As Double
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL modem.cpl", 5)
End Sub
