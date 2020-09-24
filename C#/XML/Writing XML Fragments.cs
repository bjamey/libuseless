// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Writing XML Fragments
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

static void writeTree(XmlNode xmlElement, int level) {
   String levelDepth = "";
   for(int i=0;i<level;i++)
   {
      levelDepth += "   ";
   }
   Console.Write("\n{0}<{1}",levelDepth,xmlElement.Name);
   XmlAttributeCollection xmlAttributeCollection = xmlElement.Attributes;
   foreach(XmlAttribute x in xmlAttributeCollection)
   {
      Console.Write(" {0}='{1}'",x.Name,x.Value);
   }
   Console.Write(">");
   XmlNodeList xmlNodeList = xmlElement.ChildNodes;
   ++level;
   foreach(XmlNode x in xmlNodeList)
   {
      if(x.NodeType == XmlNodeType.Element)
      {
         writeTree((XmlNode)x,  level);
      }
      else if(x.NodeType == XmlNodeType.Text)
      {
         Console.Write("\n{0}   {1}",levelDepth,(x.Value).Trim());
      }
   }
   Console.Write("\n{0}</{1}>",levelDepth,xmlElement.Name);
}
