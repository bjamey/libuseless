' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Using OleDb DataReader to read data
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Imports System.Data
Imports System.Data.OleDb

' Sample Code:

' In the sample code, I've used an Access database to read the data. Same well known steps.

' Create Connection
' Open Connection
' Create Command Object
' Call Command's ExecuteReader() to return DataReader
' and use DataReader to get the data.

Try
'construct the command object and open a connection to the Contacts table

Dim cmdString As String = "Select ContactID, FirstName, LastName from Contacts"
Dim connString As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\contactmanagement.mdb"
Dim myConnection As OleDbConnection = New OleDbConnection(connString)

' Open connection
myConnection.Open()

'Create OleDbCommand object
Dim TheCommand As OleDbCommand = New OleDbCommand(cmdString, myConnection)

TheCommand.CommandType = CommandType.Text
' Create a DataReader and call Execute on the Command Object to construct it

Dim TheDataReader As OleDbDataReader = TheCommand.ExecuteReader()

While TheDataReader.Read()
System.Console.Write(TheDataReader("ContactID").ToString())
System.Console.Write(" ")
System.Console.Write(TheDataReader("FirstName").ToString())
System.Console.Write(" ")
System.Console.Write(TheDataReader("LastName").ToString())
System.Console.WriteLine()
End While

Catch ae As OleDbException
MsgBox(ae.Message())
End Try
