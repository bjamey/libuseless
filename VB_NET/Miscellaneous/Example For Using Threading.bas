' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Example For Using Threading
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Strict Off
Imports System
Imports Microsoft.VisualBasic
Imports System.Threading


    Class MyThread
      Shared Sub main()
       Try
        'Declare a Thread and Assign it to a Methord Hi
         Dim t As New thread(AddressOf hi)
        'Declare Another Thread and assign it to Bye
         Dim b As New thread(AddressOf bye)

        'Set the priority level for each thread
         t.Priority = ThreadPriority.Normal
         b.Priority = ThreadPriority.Lowest

        'Start the thread execution
         t.start()
         b.start()
       Catch e As exception
         msgbox(e.tostring)
       End Try
      End Sub

      Shared Sub hi()
        'Infinite Loop CTRL + C to Exit
        Do While True
          console.writeline("hi")
        Loop
      End Sub

      Shared Sub bye()
        'Infinite Loop CTRL + C to Exit
         Do While True
           console.writeline("bye")
         Loop
      End Sub
   End Class
