' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get Color (RGB)
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' -----------
' Functions
' -----------

Private Function Red(ByVal Color As Long) As Integer
    Red = Color Mod &H100
End Function

Private Function Green(ByVal Color As Long) As Integer
    Green = (Color \ &H100) Mod &H100
End Function

Private Function Blue(ByVal Color As Long) As Integer
    Blue = (Color \ &H10000) Mod &H100
End Function

' ---------------
' To get color :
' (Example using text's box and one main picture)
' ---------------

Text1.text = Red(Me.Picture)
Text2.text = Green(Me.Picture)
Text3.text = Blue(Me.Picture)
