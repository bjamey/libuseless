' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrieve the short pathname version of a pathfile name
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
 ' FUNCTION GetShortPathName
 '
 ' Retrieve the short pathname version of a path possibly
 '   containing long subdirectory and/or file names
 '-----------------------------------------------------------
 '
 Function GetShortPathName(ByVal strLongPath As String) As String
     Const cchBuffer = 300
     Dim strShortPath As String
     Dim lResult As Long

     On Error GoTo 0
     strShortPath = String(cchBuffer, Chr$(0))
     lResult = OSGetShortPathName(strLongPath, strShortPath, cchBuffer)
     If lResult = 0 Then
         ' Error 53 ' File not found
         ' just use the long name as this is usually good enough
         GetShortPathName = strLongPath
     Else
         GetShortPathName = StripTerminator(strShortPath)
     End If
 End Function
