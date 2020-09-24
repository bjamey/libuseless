' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Getting a Database Tables vb·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Listing 1: Getting a Database Schema
Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
Dim str As String = "Provider=Microsoft.jet.oledb.4.0;Data Source=c:\\northwind.mdb"
Dim conn As New OleDb.OleDbConnection()
conn.ConnectionString = str
' Open a connection
conn.Open()

'Call GetOleDbSchemaTable
Dim schemaTable As DataTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, _
New Object() {Nothing, Nothing, Nothing, "TABLE"})

' Attach data row to the grid and close the connection
DataGrid1.DataSource = schemaTable
conn.Close()

End Sub

Now if you want only database table names, you can extract the data table returned by the GetOleDbSchemaTable. The code listed in Listing 2 shows how to do so.

Listing 2. Extracting a DataTable to get only table names.
Dim str As String = "Provider=Microsoft.jet.oledb.4.0;Data Source=c:\\northwind.mdb"
Dim conn As New OleDb.OleDbConnection()
conn.ConnectionString = str
' Open a connection
conn.Open()
Dim ca As Object

'Call GetOleDbSchemaTable
Dim schemaTable As DataTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, _New Object() {Nothing, Nothing, Nothing, "TABLE"})

Dim tableList As New DataTable("Table")
Dim rowvals(0) As Object
Dim newdc As New DataColumn("Col")
tableList.Columns.Add(newdc)
Dim rowcoll As DataRowCollection = tableList.Rows
Dim counter As Integer

For counter = 0 To schemaTable.Rows.Count - 1
Dim rd As DataRow = schemaTable.Rows(counter)
If rd("TABLE_TYPE").ToString = "TABLE" Then
rowvals(0) = rd("TABLE_NAME").ToString
rowcoll.Add(rowvals)
End If
Next

' Attach data row to the grid and close the connection
DataGrid1.DataSource = tableList
conn.Close()
