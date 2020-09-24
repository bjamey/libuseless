' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Convert String to ToBase64ToString method
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

  Dim strSomething As String = "SomeCoolString"
  Dim myByteArray As Byte()
  Dim a As New System.Text.ASCIIEncoding()

  myByteArray= a.GetBytes(strSomething )

  Dim myZZTop As String
  myZZTop = System.Convert.ToBase64String(myByteArray, 0, myByteArray.Length)
  ' ...Was recently trying to find a method to encode a string
  ' using ToBase64ToString method in the System.Convert class.
  ' The .NET framework makes life so easy when doing such complicated things for newbies like me!

  ' [code]
  Dim strSomething As String = "SomeCoolString"
  Dim myByteArray As Byte()
  Dim a As New System.Text.ASCIIEncoding()

  myByteArray= a.GetBytes(strSomething )

  Dim myZZTop As String
  myZZTop = System.Convert.ToBase64String(myByteArray, 0, myByteArray.Length)


  ' [code]

  Imports System.Text
  Function DecryptZZString(myZZTop as string) as String
       Dim objUTF8 As New UTF8Encoding()
       DecryptZZString= objUTF8.GetString(Convert.FromBase64String(myZZTop))
  End Function
