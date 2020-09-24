' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Drawing A Color Gradient in VB·Net
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' It can be used like this:

Protected Overrides Sub OnPaint(ByVal pe As PaintEventArgs)
    DrawGradient(Color.Blue, Color.Firebrick, Drawing.Drawing2D.LinearGradientMode.Horizontal)
End Sub

' The function is:

Private Sub DrawGradient(ByVal color1 As Color, ByVal color2 As Color, ByVal mode As System.Drawing.Drawing2D.LinearGradientMode)
    Dim a As New System.Drawing.Drawing2D.LinearGradientBrush(New RectangleF(0, 0, Me.Width, Me.Height), color1, color2, mode)
    Dim g As Graphics = Me.CreateGraphics
    g.FillRectangle(a, New RectangleF(0, 0, Me.Width, Me.Height))
    g.Dispose()
End Sub

' You can render text using a similiar method:

Private Sub DrawGradientString(ByVal text as String, ByVal color1 As Color, ByVal color2 As Color, ByVal mode As System.Drawing.Drawing2D.LinearGradientMode)
    Dim a As New System.Drawing.Drawing2D.LinearGradientBrush(New RectangleF(0, 0, 100, 19), color1, color2, mode)
    Dim g As Graphics = Me.CreateGraphics
    Dim f As Font
    f = New Font("arial", 20, FontStyle.Bold, GraphicsUnit.Pixel)
    g.DrawString(text, f, a, 0, 0)
    g.Dispose()
End Sub

' For this method it is used like this:

DrawGradientString("Hello To You", Color.blue, Color.firebrick, Drawing.Drawing2D.LinearGradientMode.Vertical)
