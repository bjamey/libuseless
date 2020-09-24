// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Create in memory PDF documents in ASP dotNET using Apache NFOP
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

//**************************************
// Name: Create in memory PDF documents in ASP.NET using Apache NFOP
// Description:The sample demonstrates how to create PDF documents in memory
// using the open source Apache NFOP(http://sourceforge.net/projects/nfop/) and
// stream the same to browser instead of saving the PDF documents to harddrive.
// By: Azeet Chebrolu
//
//
// Inputs:Path to your XML Data File and Path to the XSLT Transformation file.
//
// Returns:None
//
// Assumes:Add reference to ApacheFop.Net.dll and vJsLib.dll which comes with
//         Visual J#.net
//
// Side Effects:None
//**************************************                

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using org.apache.fop;
using org.apache.fop.apps;
using org.apache.fop.tools;
using org.xml.sax;
using java.io;
using System.Text;

public partial class output : System.Web.UI.Page
{
 protected void Page_Load(object sender, EventArgs e){}
 protected void Button1_Click(object sender, EventArgs e)
 {
  StreamPDF(Server.MapPath("CP0000001.xml"), Server.MapPath("pdf.xslt"));
 }
 private static void StreamPDF(string XMLFile,string XSLTFile)
 {
  // Load the style sheet.
  XslCompiledTransform xslt = new XslCompiledTransform();
  xslt.Load(XMLFile);
  XmlDocument objSourceData = new XmlDocument();

  //Load the Source XML Document
  objSourceData.Load(XSLTFile);

  // Execute the transform and output the results to a file.
  MemoryStream ms = new MemoryStream();
  xslt.Transform(objSourceData, null, ms);

  //Convert the Byte Array from MemoryStream to SByte Array
  sbyte[] inputFOBytes = ToSByteArray(ms.ToArray());
  InputSource inputFoFile = new org.xml.sax.InputSource(new ByteArrayInputStream(inputFOBytes));
  ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
  org.apache.fop.apps.Driver dr = new org.apache.fop.apps.Driver(inputFoFile, bos);
  dr.setRenderer(org.apache.fop.apps.Driver.RENDER_PDF);
  dr.run();

  //Convert the SByte Array to Byte Array to stream to the Browser
  byte[] getBytes = ToByteArray(bos.toByteArray());
  MemoryStream msPdf = new MemoryStream(getBytes);
  Response.ContentType = "application/pdf";
  Response.AddHeader("Content-disposition", "filename=output.pdf");
  Response.OutputStream.Write(getBytes, 0, getBytes.Length);
  Response.OutputStream.Flush();
  Response.OutputStream.Close();
 }

 private static SByte[] ToSByteArray(Byte[] source)
 {
  sbyte[] sbytes = new sbyte[source.Length];
  System.Buffer.BlockCopy(source, 0, sbytes, 0, source.Length);
  return sbytes;
 }

 private static Byte[] ToByteArray(SByte[] source)
 {
  byte[] bytes = new byte[source.Length];
  System.Buffer.BlockCopy(source, 0, bytes, 0, source.Length);
  return bytes;
 }
 public static string GetStringFromStream(Stream stream)
 {
  // Create a stream reader.
  stream.Seek(0, SeekOrigin.Begin);
  using (StreamReader reader = new StreamReader(stream))
  {
   // Just read to the end.
   return reader.ReadToEnd();
  }
 }
}
