' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Convert 8 Char Date to a Formatted Date String
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Convert 8 Char Date to a Formatted Date String
Public Function GetFormattedDate(ByVal s8CharDate As String) As String
     Dim sMonth, sDay, sYear As String

     If (IsDBNull(s8CharDate) = True) Then Return ""
     If (IsNothing(s8CharDate)) Then Return ""
     If (s8CharDate.Length >= 8) Then
         If (s8CharDate.Substring(4, 2) < 10) Then
             sMonth = s8CharDate.Substring(5, 1)
         Else
             sMonth = s8CharDate.Substring(4, 2)
         End If

         If (s8CharDate.Substring(6, 2) < 10) Then
             sDay = s8CharDate.Substring(7, 1)
         Else
             sDay = s8CharDate.Substring(6, 2)
         End If

         Return sMonth & "/" & sDay & "/" & s8CharDate.Substring(0, 4)
     End If

     Return ""
End Function                         
