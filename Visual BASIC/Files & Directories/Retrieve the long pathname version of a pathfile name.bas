' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrieve the long pathname version of a pathfile name
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION GetLongPathName
'
' Retrieve the long pathname version of a path possibly
'   containing short subdirectory and/or file names
'-----------------------------------------------------------

Function GetLongPathName(ByVal strShortPath As String) As String
    On Error GoTo 0

    MakeLongPath (strShortPath)
    GetLongPathName = StripTerminator(strShortPath)
End Function
