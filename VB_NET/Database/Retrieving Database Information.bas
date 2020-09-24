' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrieving Database Information
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Connection OleDbConnection
RecordSet OleDbDataReader
Command OleDBCommand


' Here is a small example that explains DB Connection step-by-step.

' 1) Create a New VB.NET Windows Application
' 2) Place a Command Button in the Form and name it as cmdFetchData
' 3) Import the System.Data and System.IO Namespace
' 4) Write the following code in the Click Event of the CommandButton


'Section (I)
'Variable Declaration
Dim cn As New System.Data.OleDb.OleDbConnection()
Dim dr As System.Data.OleDb.OleDbDataReader
Dim cmd As System.Data.OleDb.OleDbCommand
Dim strValue As String
Dim fS As System.IO.FileStream
Dim sW As New System.IO.StreamWriter(fS)

'Section (II)

'Setting the Database connect string
cn.ConnectionString = "Provider=MSDAORA; DataSource=Nebula;" & _
& "User ID=SCOTT;Password=TIGER"

'Establishing Database connection
cn.Open()

'Section (III)
'Create a command object to Execute a command against
Databse(Select/Insert/Update/Delete)
cmd = cn.CreateCommand()

'Setting the SQL Statement to be executed. The Statement will be a select
statement to pull 'Data from the database
cmd.CommandType = CommandType.Text
cmd.CommandText = "SELECT TABTYPE,TNAME FROM TAB"

'Call the ExecuteReader method to retrieve Data from the database
dr = cmd.ExecuteReader()

'Section (IV)
'Search for a file named F:\Data.txt and delete the file if exists
If System.IO.File.Exists("F:\Data.txt") = True Then
System.IO.File.Delete("F:\Data.txt")
End If

'Open the data file in Write mode
fS = System.IO.File.OpenWrite("F:\Data.txt")

'Section (V)
'Call the Read method to move to the Next record in the DataReader Object
'Call the GetString method to retrieve a string value from the DataReader
'Call the WriteLine function to write the the data to TextFile

Do While dr.Read
strValue = ""
strValue = strValue + dr.GetString(0)
strValue = strValue + " "
strValue = strValue + dr.GetString(1)
sW.WriteLine()
sW.Write(strValue)
Loop

'Close the Stream writer object to close the file
sW.Close()


'Description:-
'Section(1):- Object necessary to connect to database is declared, Execute a statement and retrieve data


'Section(2):- Establisheds DB Connection using the oledbconnection object

'Section(3):- Create a command object to execute the SELECT statment, Set the SQL Statement to 'be executed, Executes the statement and gets the data in Datareader

'Section(4):- Deletes the file F:\Data.txt if exists and Opens the same after creating the same 'in write mode


'Section(5):- The Read method of the data reader object is used to navigate to the next record in the object and the GetString function is used to retrieve the data from the DataReader. The data retrieved is written to the text file using the streamWriter object that is attached to the File.
