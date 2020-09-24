' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Working with Brushes in GDI + VB·NET Version
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Drawing GDI+ Objects
' The following code draws a line, an ellipse, a curve, and a polygon object. As you can see from the code, I¡¯ve used pen object to fill these objects. See more details.

protected overrides sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
Dim g As Graphics = e.Graphics
Dim pn As Pen = New Pen(Color.Green, 10)
g.DrawLine(pn, 100, 10, 30, 10)
g.DrawEllipse(New Pen(Color.Red, 20), 20, 40, 20, 20)
g.DrawBezier(New Pen(Color.Blue, 5), New Point(50, 60), New Point(150, 10), New Point(200, 230), New Point(100, 100))
Dim point1 As PointF = New PointF(50F, 250F)
Dim point2 As PointF = New PointF(100F, 25F)
Dim point3 As PointF = New PointF(150F, 5F)
Dim point4 As PointF = New PointF(250F, 50F)
Dim point5 As PointF = New PointF(300F, 100F)
Dim curvePoints As PointF() = {point1, point2, point3, point4, point5}
g.DrawPolygon(New Pen(Color.Chocolate, 10), curvePoints)

End Sub

' Brush and Brushes Types
' Brush type is an abstract base class. HatchBrush, LinearGradientBrush, PathGradientBrush, SolidBrush and TextureBrush classes are inherited from Brush class. You don¡¯t use this class directly.

' All brush types are defined in System.Drawing and its helper namespaces. Before using brushes, you need to add reference to this namespace. HatchBrush and GradientBrush are defined in System.Drawing.Drawing2D namespace.

' You use brushes to fill GDI+ objects with certain kind of brush. You generally call Fill methods of Graphics class to fill various objects such as Ellipse, Arc, or Polygon. There are different kinds of brushes. For example, solid brush, hatch brush, texture brush, and gradient brush.

' Solid Brushes
' Solid brushes are normal brushes with no style. You fill GDI+ object with a color. SolidBrush type is used to work with solid brushes.

Dim g As Graphics = e.Graphics
Dim sdBrush1 As SolidBrush = New SolidBrush(Color.Red)
Dim sdBrush2 As SolidBrush = New SolidBrush(Color.Green)
Dim sdBrush3 As SolidBrush = New SolidBrush(Color.Blue)
g.FillEllipse(sdBrush2, 20, 40, 60, 70)
Dim rect As Rectangle = New Rectangle(0, 0, 200, 100)
g.FillPie(sdBrush3, 0, 0, 200, 40, 0F, 30F)
Dim point1 As PointF = New PointF(50F, 250F)
Dim point2 As PointF = New PointF(100F, 25F)
Dim point3 As PointF = New PointF(150F, 5F)
Dim point4 As PointF = New PointF(250F, 50F)
Dim point5 As PointF = New PointF(300F, 100F)
Dim curvePoints As PointF() = {point1, point2, point3, point4, point5}

g.FillPolygon(sdBrush1, curvePoints)

' Hatch Brushes
using System.Drawing.Drawing2D;

' The hatch brushes are brushes with a hatch style, a foreground color, and a background color. Hatches are a combination of rectangle lines and the area between the lines. The foreground color defines the color of lines; the background color defines the color of area between lines.

' HatchStyle defines the hatch styles.

Member Name

BackwardDiagonal

Cross

DarkDownwardDiagonal

DarkHorizontal

DarkUpwardDiagonal

DarkVertical

DashedDownwardDiagonal

DashedHorizontal

DashedUpwardDiagonal

DashedVertical

DiagonalBrick

DiagonalCross

Divot

DottedDiamond

DottedGrid

ForwardDiagonal


' The following code shows how to draw hatch brushes.


Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
Dim g As Graphics = e.Graphics

Dim hBrush1 As HatchBrush = New HatchBrush(HatchStyle.DiagonalCross, Color.Chocolate, Color.Red)
Dim hBrush2 As HatchBrush = New HatchBrush(HatchStyle.DashedHorizontal, Color.Green, Color.Black)
Dim hBrush3 As HatchBrush = New HatchBrush(HatchStyle.Weave, Color.BlueViolet, Color.Blue)

g.FillEllipse(hBrush1, 20, 80, 60, 20)
Dim rect As Rectangle = New Rectangle(0, 0, 200, 100)

Dim point1 As PointF = New PointF(50F, 250F)
Dim point2 As PointF = New PointF(100F, 25F)
Dim point3 As PointF = New PointF(150F, 5F)
Dim point4 As PointF = New PointF(250F, 50F)
Dim point5 As PointF = New PointF(300F, 100F)
Dim curvePoints As PointF() = {point1, point2, point3, point4, point5}
g.FillPolygon(hBrush2, curvePoints)

End Sub

' Texture Brushes
' The texture brushes provides you to use an image as brush and fill GDI+ objects with the brush. The following code use ¡°myfile.bmp¡± as a brush. You need to define an Image object and create brush with that Image and pass the brush into Fill method of GDI+ objects.

Dim txBrush As TextureBrush
¡­¡­

Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)

Dim g As Graphics = e.Graphics
g.FillRectangle(txBrush, ClientRectangle)

End Sub



Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

Dim img As Image = New Bitmap("C:\\myfile.bmp")
txBrush = New TextureBrush(img)

End Sub

' Gradient Brushes
' Gradient brushes provides more color to your GDI+ objects. By using LinearGradientBrush type, you can blend two colors together. The following code blends red and green colors.

Dim g As Graphics = e.Graphics
Dim rect As Rectangle = New Rectangle(50, 30, 200, 200)
Dim lBrush As LinearGradientBrush = New LinearGradientBrush(rect, Color.Blue, Color.Green, LinearGradientMode.Vertical)
g.FillRectangle(lBrush, rect)
This like combines blue and green colors -

Dim lBrush As LinearGradientBrush = New LinearGradientBrush(rect, Color.Blue, Color.Green, LinearGradientMode.Vertical)
