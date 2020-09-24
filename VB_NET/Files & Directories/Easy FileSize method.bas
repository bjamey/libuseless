' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Easy FileSize method
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Retrieve file size in VB.NET

Public Shared Function FileSize(ByVal path As String) As String
       Dim myFile As FileInfo
       Dim mySize As Single

       try
          myFile = New FileInfo(path)

          If Not myFile.Exists Then
             mySize = 0
          Else
              mySize = myFile.Length
          End If

          Select Case mySize
               Case 0 To 1023
                    Return mySize & " bytes"

               Case 1024 To 1048575
                    Return Format(mySize / 1024, "###0.00") & " kB"

               Case 1048576 To 1043741824
                    Return Format(mySize / 1024 ^ 2, "###0.00") & " mB"

               Case Is > 1043741824
                    Return Format(mySize / 1024 ^ 3, "###0.00") & " gB"
          End Select

          Return "0 bytes"

       Catch ex As Exception
             Return "0 bytes"
       End Try
End Function
