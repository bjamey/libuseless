' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Implementing Inheritance in VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Creation of Car Object
Public Class Car

Public Color As String
Private numberOfDoors As Integer

' Constructor...
Sub New()
' set the defaults:
Color = "White"
numberOfDoors = 5
End Sub

Property NumberOfDoors() As Integer
' called when the property is "got"...
Get
Return numberOfDoors
End Get
End Property

End Class

' Inheriting of the Car Object..
Public Class SportsCar
Inherits Car
Public Weight As Integer
End Class

' Module where the real instance of Car and SportsCar Object are Utilized.
Module Module1

Sub Main()
' create a new car object...
Dim myCar As SportsCar
myCar = New SportsCar()

' set the weight (kg)...
myCar.Weight = 1085

' report the details...
Console.WriteLine("Weight:" & myCar.Weight)
' wait...
Console.ReadLine()
End Sub

End Module
