// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Serializing and Deserializing XML String
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

//This will returns the set of included namespaces for the serializer.
public static XmlSerializerNamespaces GetNamespaces()
{

XmlSerializerNamespaces ns;
ns = new XmlSerializerNamespaces();
ns.Add("xs", "http://www.w3.org/2001/XMLSchema");
ns.Add("xsi", "http://www.w3.org/2001/XMLSchema-instance");
return ns;

}

 //Returns the target namespace for the serializer.
public static string TargetNamespace
{

Get
{

return http://www.w3.org/2001/XMLSchema;
}

}

 //Creates an object from an XML string.
public static object FromXml(string Xml, System.Type ObjType)
{

XmlSerializer ser;
ser = new XmlSerializer(ObjType);
StringReader stringReader;
stringReader = new StringReader(Xml);
XmlTextReader xmlReader;
xmlReader = new XmlTextReader(stringReader);
object obj;
obj = ser.Deserialize(xmlReader);
xmlReader.Close();
stringReader.Close();
return obj;

}

 //Serializes the <i>Obj</i> to an XML string.
public static string ToXml(object Obj, System.Type ObjType)
{

XmlSerializer ser;
ser = new XmlSerializer(ObjType, SerializeObject.TargetNamespace);
MemoryStream memStream;
memStream = new MemoryStream();
XmlTextWriter xmlWriter;
xmlWriter = new XmlTextWriter(memStream, Encoding.UTF8);
xmlWriter.Namespaces = true;
ser.Serialize(xmlWriter, Obj, SerializeObject.GetNamespaces());
xmlWriter.Close();
memStream.Close();
string xml;
xml = Encoding.UTF8.GetString(memStream.GetBuffer());
xml = xml.Substring(xml.IndexOf(Convert.ToChar(60)));
xml = xml.Substring(0, (xml.LastIndexOf(Convert.ToChar(62)) + 1));
return xml;

}
