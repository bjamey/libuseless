' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Display Windows Accessability Properties Dialog
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' -------
' Code
' -------

Sub AccessabilityDialog_Keyboard()
    ' Launch Accessability Properties Dialog (Keyboard Tab)

    Dim dblReturn As Double
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL access.cpl,,1", 1)
End Sub

' ================================================================= '

Sub AccessabilityDialog_Sound()
    ' Launch Accessability Properties Dialog (Sound Tab)

    Dim dblReturn As Double
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL access.cpl,,2", 1)
End Sub

' ================================================================= '

Sub AccessabilityDialog_Display()
    ' Launch Accessability Properties Dialog (Display Tab)

    Dim dblReturn As Double
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL access.cpl,,3", 1)
End Sub

' ================================================================= '

Sub AccessabilityDialog_Mouse()
    ' Launch Accessability Properties Dialog (Mouse Tab)

    Dim dblReturn As Double
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL access.cpl,,4", 1)
End Sub

' ================================================================= '

Sub AccessabilityDialog_General()
    ' Launch Accessability Properties Dialog (General Tab)

    Dim dblReturn As Double
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL access.cpl,,5", 1)
End Sub
