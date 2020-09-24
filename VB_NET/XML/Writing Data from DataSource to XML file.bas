' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Writing Data from DataSource to XML file
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' write dataset contents to an xml file
ds.WriteXml("C:\\out.xml")

' Before that same old steps. Create a connection object, create dataadapter and call fill method of data adapter to fill a dataset.

Dim cmdString As String = "Select ContactID, FirstName, LastName from Contacts"
Dim connString As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\contactmanagement.mdb"
Dim myConnection As OleDbConnection = New OleDbConnection(connString)
' Open connection
myConnection.Open()
'create data adapter and dataset objects
Dim da As OleDbDataAdapter = New OleDbDataAdapter(cmdString, myConnection)
Dim ds As DataSet = New DataSet()

' fill dataset
da.Fill(ds, "Contacts")



' Source Code:

Imports System
Imports System.Data
Imports System.Data.OleDb
Module Module1
Sub Main()
'construct the command object and open a connection to the Contacts table
Dim cmdString As String = "Select ContactID, FirstName, LastName from Contacts"
Dim connString As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\contactmanagement.mdb"
Dim myConnection As OleDbConnection = New OleDbConnection(connString)
' Open connection
myConnection.Open()
'create data adapter and dataset objects
Dim da As OleDbDataAdapter = New OleDbDataAdapter(cmdString, myConnection)
Dim ds As DataSet = New DataSet()

' fill dataset
da.Fill(ds, "Contacts")

' write dataset contents to an xml file
ds.WriteXml("C:\\out.xml")

End Sub
End Module
