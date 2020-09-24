' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Convert the Color structure to HTML and vice versa
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' --------------------
' Color --> HTML
' --------------------

Public Function Color2Html(ByVal clr As Color) As String
       Return "#" & clr.ToArgb().ToString("x").Substring(2)
End Function

' ---------
' Usage:
' ---------

Dim myHTML As String = Color2Html(Color.Blue)
' myHTML now contains #0000FF



' --------------------
' HTML --> Color
' --------------------

Dim cc As System.Drawing.ColorConverter = New System.Drawing.ColorConverter
Me.BackColor = cc.ConvertFromString("#3FF134")
