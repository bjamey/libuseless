<!-- --------------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Dynamically Generate Images in Web Pages

   Date : 15/05/2007
   By   : FSL
--------------------------------------------------------------------------- -->

<!-- Dynamically Generate Images in Web Pages -->

<!-- If you want to dynamically generate an image and display the image in a Web
 Page, then you actually need to create two ASP.NET pages. You create one page
 that generates the byte data for the actual image. This page is then displayed
 in a second page, the display page, with an HTML <img>  tag.
 This example creates a pair of pages that displays a red circle. We'll generate
 a GIF image for the circle in an ASP.NET page named Circle.aspx.
-->

<!-- 1. Circle.aspx -->
-----------

<%@ Page ContentType="image/gif" %>
<%@ Import namespace="System.Drawing" %>
<%@ Import namespace="System.Drawing.Imaging" %>
<Script Runat="Server">
Sub Page_Load
    Dim objBitmap As Bitmap
    Dim objGraphics As Graphics

    ' Create Bitmap
    objBitmap = New Bitmap( 200, 200 )

    ' Initialize Graphics Class
    objGraphics = Graphics.FromImage( objBitmap )
    objGraphics.FillEllipse( Brushes.Red, 0, 0, 200, 200 )

    ' Display Bitmap
    objBitmap.Save( Response.OutputStream, ImageFormat.Gif )
End Sub
</Script>


<!--
The purpose of the ContentType directive that appears at the very top of the
page is to actually pretend that ASP .NET page to be a GIF image. When the page
is requested, the ContentType directive tells the Web browser that it should
expect a GIF image instead of a normal HTML page.
Normally you will need to open the page in a second page to use it effectively
in a web page.
The second page contains an HTML <img> tag that loads the above page. This page
contains normal HTML content that appears around the image.
-->


<!-- 2. DisplayCircle.aspx -->


<html>
      <head><title>DisplayCircle.aspx</title></head>
      <body>
            <h1>Here is an image:</h1>
            <img src="Circle.aspx">
            <h1>The image appears above!<h1>
      </body>
</html>

<!--
The Web browser treats the Circle.aspx page as a normal GIF image. It has no
idea that the image was dynamically generated in an ASP.NET page.
-->
