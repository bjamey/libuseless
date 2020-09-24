' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Strip HTML Tags From a String
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' --------------------------------------------
' This will strip HTML Tags From a String
'
'(.|\n) -- Finds any character including the new line character
'
' *?  -- 0 or more occurences and the match will stop at the first
' occuring ">" it sees
' --------------------------------------------

Dim StrippedString As String

StrippedString = Regex.Replace(htmlString, "<(.|\n)*?>", string.Empty)
