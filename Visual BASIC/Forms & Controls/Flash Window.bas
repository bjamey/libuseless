' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Flash Window
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ---------------
' Place in a module
' ---------------

Private Declare Function FlashWindow Lib "user32" Alias "FlashWindow" (ByVal hwnd As Long, ByVal bInvert As Long) As Long

' ------------------
' Place in your work
' ------------------
Private Sub Form_Load()
    Timer1.Interval = 300 'Change value depending On the speed of flahing.
End Sub


Private Sub Timer1_Timer()
    FlashWindow hwnd, 1
End Sub
