' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Converting Image Formats
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' This code snippet uses System.Drawing namespace to convert the image formats. This simple but effective VB.NET and C# application accepts an image file as input and converts it to a variety of file formats viz. GIF, JPG, TIFF etc. For Simplicity this application converts an supplied Image file into .GIF format. With a simple modification this application can be extended to a full fledge "Image Converter", I would keep the options open for you all :)
' Author: Manish Mehta

Imports System
Imports System.Drawing

Class ConvertImageFormats
    Shared Sub main()
         Dim strFileToConvert As String

         Console.Write("Image File to Convert :")
         strFileToConvert = Console.ReadLine()

         ' Initialize the bitmap object by supplying the image file path
         Dim b As New Bitmap(strFileToConvert)

         'Convert the file in GIF format, also check out other
         ' formats like JPG, TIFF
         b.Save(strFileToConvert + ".gif",  System.Drawing.Imaging.ImageFormat.Gif)
         Console.Write("Sucessfully Converted to " & strFileToConvert & ".gif")
    End Sub
End Class

' Check out the relevent C# code to convert the image formats.
' Bitmap b;

mybmp Bitmap = new Bitmap("FileName");
b.Save("FileName", System.Drawing.Imaging.ImageFormat.Gif);
