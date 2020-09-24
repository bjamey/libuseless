' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get File Attributes in VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Imports System.IO

Public Module modmain
   Sub Main()
      If (File.GetAttributes("c:\autoexec.bat") _
         And FileAttributes.Hidden) _
         = FileAttributes.Hidden Then
         Console.WriteLine("Hidden")
      Else
         Console.WriteLine("Not Hidden")
      End If
   End Sub
End Module                                     
