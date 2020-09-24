' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Programming Delegates
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Delegate Definition
Public Delegate Sub mySingleCast(ByVal value As String)
Class myEcho
Public Sub Shout(ByVal Value As String)
MsgBox(Value)
End Sub
End Class
Class proVerb
Public Sub Verb(ByVal Value As String)
MsgBox(Value)
End Sub
End Class
Private Sub btnDelegate_Click(ByVal sender As System.Object, _
ByVal e As System.EventArgs) Handles btnDelegate.Click
' Declaration Section
Dim objMyEcho As New myEcho()
Dim objproVerb As New proVerb()
Dim dlgt As mySingleCast

' Assign the Function Pointer to delegate
dlgt = New mySingleCast(AddressOf objMyEcho.Shout)

' Call the Invoke Method of Delegate
dlgt.Invoke("Enjoy .Net Programming")

' Assign the Function Pointer of another class to delegate
dlgt = New mySingleCast(AddressOf objproVerb.Verb)

' Calling Invoke Method of Delegate
dlgt.Invoke("God is Great")

