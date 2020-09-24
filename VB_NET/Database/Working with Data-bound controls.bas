' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Working with Data-bound controls
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' You need to add these namespaces before using ADO.NET components.

Imports System
Imports System.Data
Imports System.Data.SqlClient

' DataGrid Control

' Add a datagrid control to a form and write the following code. Change your data source, table and column names if you're using different databases.

Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
Dim cmdString As String = "Select * from Employees"
Dim connString As String = "user id=sa;password=;database=northwind;server=MCB"
Dim myConnection As SqlConnection = New SqlConnection(connString)

Try
' Open connection
myConnection.Open()
Dim da As SqlDataAdapter = New SqlDataAdapter(cmdString, myConnection)
Dim dataSet1 As DataSet = New DataSet()
da.Fill(dataSet1, "Employees")
DataGrid1.DataSource = dataSet1.DefaultViewManager
Catch ae As SqlException
MessageBox.Show(ae.Message)
End Try
End Sub


' ListBox Control

' Add a list box control to a form and add the following code to the form load event.

Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
Dim cmdString As String = "Select * from Employees"
Dim connString As String = "user id=sa;password=;database=northwind;server=MCB"
Dim myConnection As SqlConnection = New SqlConnection(connString)

Try
' Open connection
myConnection.Open()
Dim da As SqlDataAdapter = New SqlDataAdapter(cmdString, myConnection)
Dim dataSet1 As DataSet = New DataSet()
da.Fill(dataSet1, "Employees")
ListBox1.DataSource = dataSet1.DefaultViewManager
ListBox1.DisplayMember = "LastName"

Catch ae As SqlException
MessageBox.Show(ae.Message)
End Try
End Sub


' Combo Box

' Just add a combo box to a form and add the following code:

Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
Dim cmdString As String = "Select * from Employees"
Dim connString As String = "user id=sa;password=;database=northwind;server=MCB"
Dim myConnection As SqlConnection = New SqlConnection(connString)

Try
' Open connection
myConnection.Open()
Dim da As SqlDataAdapter = New SqlDataAdapter(cmdString, myConnection)
Dim dataSet1 As DataSet = New DataSet()
da.Fill(dataSet1, "Employees")
Dim DataViewManager1 As DataViewManager = dataSet1.DefaultViewManager
ComboBox1.DataSource = DataViewManager1
ComboBox1.DisplayMember = "Employees.FirstName"

Catch ae As SqlException
MessageBox.Show(ae.Message)
End Try
End Sub
