' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Simple Console Application
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports system
Imports microsoft.visualbasic ' For msgbox

Namespace N1
    Class Ovrl
      Shared Sub main()
        myfunc("Mansih")
        myfunc(22)
      End Sub

      'Accepts Integer
      Overloads Shared Function myfunc(ByVal i As Integer) As String
        msgbox("Overloaded Function Accepting Integer")
      End Function

     'Accepts String
     Overloads Shared Function myfunc(ByVal s As String) As String
        msgbox("Overloaded Function Accepting String")
     End Function
   End Class
End Namespace

This Example Demonstrated Function Overloading, It is also possible to overload a Constructor and its also one of my favourite feature.

Imports system
Imports microsoft.visualbasic ' For msgbox


Namespace N1
    Class OvrConst
      Shared Sub main()
        Dim o As New OvrConst()
        Dim x As New OvrConst("Constructor 2")
      End Sub

      'cosntructor 1 without parameter
      Public Overloads Sub New()
         msgbox("Constructor 1")
      End Sub


      'cosntructor 2 with a String parameter
      Public Overloads Sub New(ByVal s As String)
        msgbox(s)
      End Sub

    End Class
End Namespace
