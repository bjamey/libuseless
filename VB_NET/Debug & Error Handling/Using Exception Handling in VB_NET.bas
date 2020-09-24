' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Using Exception Handling in VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Imports Microsoft.VisualBasic ' For MsgBox
    Class MyExceptionClass
      Shared Sub main()
        Dim s(3) As String
        Try
        'Try to cause an Exception
          MsgBox(s(5))

         'Catch the raised Exception
        Catch e As Exception
          MsgBox (e.Message)

        'This block will be executed in any case
        Finally
          MsgBox ("Finally Fired")
        End Try
      End Sub
    End Class

' Lets see how we can have multiple Catch Statements to catch a specific type of error and act upon it.

' Remember:
' We can have multiple Catch statements but be very specific in declaring the sequence of Catch blocks because if a Catch block handling generic exception is preceding the Catch block handling the specific type of exception, the exception will be handled by the generic Catch block hence defeating the purpose.

' This example illustrates the use of multiple Catch Blocks

Imports System
Imports Microsoft.VisualBasic ' For MsgBox

    Class MyExceptionClass
      Shared Sub main()
        Dim s(3) As String
      Try
       'Try to cause an Exception
        MsgBox(s(5))

       'This is a Specific Exception handling catch block
       'Only IndexOutOfRange Exception will he caught here
      Catch e As IndexOutOfRangeException
        msgbox("Do something Special")

       'This is a generic Exception handling Catch block
       'Be sure to place it after your Sepecific Catch block
      Catch e As Exception
        msgbox(e.Message)

       'This block will be executed in any case
      Finally
        msgbox("Finally Fired")
      End Try
    End Sub
End Class
