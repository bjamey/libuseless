' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Saving Images in Database
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Its fairly easy to save a Image in the database using .NET OleDB library, for simplicity I have used MsAccess Database with two Fields,
' FieldName Type
' Pic OLE Object
' FileSize Text
' Author: Manish Mehta
'
'
' FieldName                      Type
' Pic OLE                       Object
' FileSize                       Text

' The following code establishes a database connection and inserts a file in the "Pic" field.
'
' Save the file as SaveImage.vb

Imports System
Imports System.IO
Imports System.Data

Public Class SaveImage
  Shared Sub main()
  'Delaclare a file stream object
  Dim o As System.IO.FileStream
  'Declare a stream reader object
  Dim r As StreamReader
  Dim jpgFile As String
  Console.Write("Enter a Valid .JPG file path")
  jpgFile = Console.ReadLine
  If Dir(jpgFile) = "" Then
   Console.Write("Invalid File Path")
   Exit Sub
  End If
  'Open the file
  o = New FileStream(jpgFile, FileMode.Open, FileAccess.Read, FileShare.Read)
  'Read the output in a stream reader
  r = New StreamReader(o)
  Try
    'Declare an Byte array to save the content of the file to be saved
    Dim FileByteArray(o.Length - 1) As Byte
    o.Read(FileByteArray, 0, o.Length)
'Open the DataBase Connection, Please map the datasource name to match the 'Database path
    Dim Con As New System.Data.OleDb.OleDbConnection("Provider=Microsoft.Jet.OLEDB.3.51;Persist Security Info=False;Data Source=DbImages.mdb")
    Dim Sql As String = "INSERT INTO DbImages (Pic,FileSize) VALUES (?,?)"
    'Declare a OleDbCommand Object
    Dim CmdObj As New System.Data.OleDb.OleDbCommand(Sql, Con)
    'Add the parameters
    CmdObj.Parameters.Add("@Pic", System.Data.OleDb.OleDbType.Binary, o.Length).Value = FileByteArray
   CmdObj.Parameters.Add("@FileSize", System.Data.OleDb.OleDbType.VarChar, 100).Value = o.Length
  Con.Open()
  CmdObj.ExecuteNonQuery()
  Con.Close()
  Catch ex As Exception
    Console.Write(ex.ToString)
  End Try
 End Sub
End Class

' Compile the file as
' vbc SaveImage.vb /r:system.data.dll /r:system.dll
' A file will be inserted in the Database each time we execute SaveImage.exe.
