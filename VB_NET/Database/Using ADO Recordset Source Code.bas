' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Using ADO Recordset Source Code
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
' Create a connection string
Dim ConnectionString As String = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=c:\\Northwind.mdb"
Dim sql As String = "SELECT CustomerId, CompanyName, ContactName From Customers"

' Create a Connection object and open it
Dim conn As Connection = New Connection()
Dim connMode As Integer = ConnectModeEnum.adModeUnknown
conn.CursorLocation = CursorLocationEnum.adUseServer
conn.Open(ConnectionString, "", "", connMode)
Dim recAffected As Object
Dim cmdType As Integer = CommandTypeEnum.adCmdText
Dim rs As _Recordset = conn.Execute(sql)

' Create dataset and data adpater objects
Dim ds As DataSet = New DataSet("Recordset")
Dim da As OleDbDataAdapter = New OleDbDataAdapter()

' Call data adapter's Fill method to fill data from ADO
' Recordset to the dataset

da.Fill(ds, rs, "Customers")

' Now use dataset
DataGrid1.DataSource = ds.DefaultViewManager

