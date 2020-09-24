' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Allow only Numbers in a Textbox Control
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Allow only numbers when someone types in a textbox control
' Add a textbox to the form and name is: txt . Then put the following
' code in the Key_Press event of the textbox control.

If e.KeyChar.IsNumber(e.KeyChar) = False Then
   e.Handled = True
End If
