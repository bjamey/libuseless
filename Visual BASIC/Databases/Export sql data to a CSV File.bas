' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Export sql data to a CSV File
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ********************************************************
' * Programmer Name  : Waty Thierry
' * Module Name      : Database_Module
' * Module Filename  : Database.bas
' * Procedure Name   : CSVExport
' * Parameters       :
' *                    db As DAO.Database
' *                    sSQL As String
' *                    sDest As String
' ********************************************************
' * Comments         : Export sql data to a CSV File
' *
' *
' ********************************************************

Public Function CSVExport(db As DAO.Database, sSQL As String, sDest As String) As Boolean
   Dim record        As Recordset
   Dim nI            As Long
   Dim nJ            As Long
   Dim nFile         As Integer
   Dim sTmp          As String

   On Error GoTo Err_Handler

   Set record = db.OpenRecordset(sSQL, DAO.dbOpenDynaset, DAO.dbReadOnly)

   ' *** Open output file
   nFile = FreeFile

   Open sDest For Output As #nFile

   ' *** Export fields name
   For nI = 0 To record.Fields.Count - 1
      sTmp = "" & (record.Fields(nI).Name)
      Write #nFile, sTmp;
   Next
   Write #nFile,

   If record.RecordCount > 0 Then
      record.MoveLast
      record.MoveFirst

      For nI = 1 To record.RecordCount
         For nJ = 0 To record.Fields.Count - 1
            sTmp = "" & (record.Fields(nJ))
            Write #nFile, sTmp;
         Next
         Write #nFile,
         record.MoveNext
      Next
   End If

   Close #nFile
   CSVExport = True

   Exit Function

Err_Handler:
   MsgBox ("Error: " & Err.Description)
   CSVExport = False
End Function
