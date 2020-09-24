' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Force numbers only in a text box
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Force numbers only in a text box
' place this in the 'Keypress' event of a text box

' -------------
' 1st Method
' -------------
Const Number$ = "0123456789." ' only allow these characters

If KeyAscii <> 8 Then
   If InStr(Number$, Chr(KeyAscii)) = 0 Then
      KeyAscii = 0
      Exit Sub
   End If
End If

' -------------
' 2nd Method
' -------------

' Force numbers only in a text box
If IsNumeric(Chr(KeyAscii)) <> True Then KeyAscii = 0
