' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Write relational data to an XML file
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' create a connection string
Dim connString As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\Northwind.mdb"
Dim myConnection As OleDbConnection = New OleDbConnection()
myConnection.ConnectionString = connString
' create a data adapter
Dim da As OleDbDataAdapter = New OleDbDataAdapter("Select * from Customers", myConnection)
' create a new dataset
Dim ds As DataSet = New DataSet()
' fill dataset
da.Fill(ds, "myTable")
' write dataset contents to an xml file by calling WriteXml method
ds.WriteXml("C:\\CustTableDt.xml")

' The portion of XML file looks like the following:

<?xml version="1.0" standalone="yes" ?>
- <NewDataSet>
- <myTable>
  <CustomerID>ALFKI</CustomerID>
  <CompanyName>Alfreds Futterkiste</CompanyName>
  <ContactName>Maria Anders</ContactName>
  <ContactTitle>Sales Representative</ContactTitle>
  <Address>Obere Str. 57</Address>
  <City>Berlin</City>
  <PostalCode>12209</PostalCode>
  <Country>Germany</Country>
  <Phone>030-0074321</Phone>
  <Fax>030-0076545</Fax>
  </myTable>
- <myTable>
