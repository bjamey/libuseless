' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Passing by Value and byReference IN VB·NET
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Imports Microsoft.visualbasic

Class TestRef

  Sub Change(ByRef i As String)
    i = "Changed"
  End Sub

  Sub DontChange(ByVal i As String)
    i = "Some Text"
  End Sub

End Class

Class PassValue

  Shared Sub main()
    Dim objT As New TestRef()
    Dim sChange As String = "DotNetExtreme"
    Dim sDontChange As String = "DotNetExtreme"

    'Value of sChange will change
    MsgBox("Before = " & sChange)
    objT.Change(sChange)
    MsgBox("After = " & sChange)

    'Value of sDontChange will not change
    MsgBox("Before = " & sDontChange)
    objT.DontChange(sDontChange)
    MsgBox("After = " & sDontChange)

  End Sub
End Class

' Compile the file from the command prompt as VBC Passval.vb
