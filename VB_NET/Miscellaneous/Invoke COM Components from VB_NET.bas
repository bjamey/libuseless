' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Invoke COM Components from VB·NET (demo included)
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

<Author        : Pramod Kumar Singh/>
'<Date          : 6 th Jan 2000 />
'<Company       : ConcretioIndia Pvt Ltd. Nagpur />
'<Purpose       : Calling COM Components from .NET environment />
'<History       :                           />


'Import Reflection Namspace which supports COM interoperability
Imports System.Reflection
Imports System.Threading
'<Summary>
'We will try to call Excel application from .NET environment
'This is a latebinding application
'for early binding u have to use RCW(RunTime Callable Wrraper) of COM Object
'to do so use command line tool tblimp
'ex.     c:\> tblimp <name.dll> /out:<name.dll>
'</Summary>
Module Module1
    Sub Main()
        'Define a variable to hold the Excel application
        Dim excel As Type
        Dim excelobject As Object
        Try
            'Get the excel object
            excel = Type.GetTypeFromProgID("Excel.Application")
            'Create instance of excel
            excelobject = Activator.CreateInstance(excel)
            'Set the parameter whic u want to set
            Dim parameter(1) As Object
            parameter(0) = True
            'Set the Visible property
            excel.InvokeMember("Visible", _
            BindingFlags.SetProperty, Nothing, _
             excelobject, parameter)
        Catch e As Exception
            Console.WriteLine("Error Stack {0} ", e.Message)
        Finally
            'When this object is destroyed the Excel
            'application will be closed
            'So Sleep for sometime and see the excel application
            Thread.Sleep(5000)
            'Relaese the object
            'GC.RunFinalizers()
        End Try
    End Sub
End Module
