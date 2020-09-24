' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Reading XML Files
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' After calling read method, you can go though the document node by node and get the data.

' Source Code:
Imports System
Imports System.Xml
Module Module1

Sub Main()
' Open an XML file
Dim reader As XmlTextReader = New XmlTextReader("C:\\out.xml")

While reader.Read()
Console.WriteLine(reader.Name)
End While

End Sub

End Module
