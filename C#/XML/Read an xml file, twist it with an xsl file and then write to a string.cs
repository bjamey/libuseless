// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Read an xml file, twist it with an xsl file and then write to a string
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.IO;
using System.Xml;
using System.Xml.Xsl;

class WriteXMLViaXSL
{
    //read an xml file, twist it with an xsl file and then write to a string (no error checking)
    //by mitchfincher@yahoo.com
    public static void Main(string[] args)
    {
    XmlDocument xmlDocument = new XmlDocument();
    xmlDocument.Load(args[0]);

    XslTransform xslTransform = new XslTransform();
    xslTransform.Load(args[1]);


    StringWriter stringWriter = new StringWriter();
    XmlTextWriter xmlTextWriter = new XmlTextWriter(stringWriter);
    xmlTextWriter.Formatting = Formatting.Indented;
    xslTransform.Transform(xmlDocument, null, xmlTextWriter);

    xmlTextWriter.Flush();
    Console.Write(stringWriter.ToString());
    }
}                              
