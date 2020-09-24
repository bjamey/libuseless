' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Add filling char between a consecutive character is the original string
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' "Explode" a string by inserting a given filling character
' between consecutive characters in the original string
'
' The source string cannot contain Chr$(0) characters

Function ExplodeString(ByVal Source As String, Optional ByVal fillChar As Char = _
    " "c) As String

    Dim i As Integer
    Dim sb As New Text.StringBuilder(Source.Length * 2)

    ' exit if no character
    If Source Is Nothing OrElse Source.Length = 0 Then Return ""

    ' inserts the first char
    sb.Append(Source.Chars(0))

    ' insert the filling char before each character
    For i = 1 To Source.Length - 1
        sb.Append(fillChar)
        sb.Append(Source.Chars(i))
    Next

    Return sb.ToString
End Function                 
