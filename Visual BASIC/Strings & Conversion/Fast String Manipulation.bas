' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Fast String Manipulation
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

Private lPosition As Long
Private strBigString As String

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDst As Any, pSrc As Any, ByVal ByteLen As Long)
Public Sub AddToString(strAdd As String)
    ' If the current position + length of string to add is greater
    ' than the length of the BigString, then increase the size of
    ' the BigString
    If lPosition + LenB(strAdd) > LenB(strBigString) Then strBigString = strBigString & Space$(10000)

    ' Add strAdd to the BigString
    CopyMemory ByVal StrPtr(strBigString) + lPosition, ByVal StrPtr(strAdd), LenB(strAdd)

    ' Move the pointer to show where the end of the string is
    lPosition = lPosition + LenB(strAdd)
End Sub

Public Property Get ReturnString() As String
    ' Trim off the blank characters and return the string
    strBigString = left$(strBigString, lPosition \ 2)      'trim back to size
    ReturnString = strBigString
End Property

Private Sub Class_Initialize()
    'Set the starting position of the BigString to 0
    lPosition = 0
End Sub

Public Sub Initialise()
    ' Re-Initialise String
    lPosition = 0
    strBigString = vbNullString
End Sub

Public Sub ReplaceEx(sFind As String, sReplace As String, bCompare As VbCompareMethod)
    strBigString = Replace$(strBigString, sFind, sReplace, , , bCompare)
End Sub

Public Sub AddNewString(strAdd As String)
    ' Re-Initialise String
    lPosition = 0
    strBigString = vbNullString

    AddToString strAdd
End Sub

Public Sub AddToStringEx( _
        Optional ByVal strAdd1 As String, _
        Optional ByVal strAdd2 As String, _
        Optional ByVal strAdd3 As String, _
        Optional ByVal strAdd4 As String, _
        Optional ByVal strAdd5 As String _
    )

    If Len(strAdd1) <> 0 Then AddToString strAdd1
    If Len(strAdd2) <> 0 Then AddToString strAdd2 Else Exit Sub
    If Len(strAdd3) <> 0 Then AddToString strAdd3 Else Exit Sub
    If Len(strAdd4) <> 0 Then AddToString strAdd4 Else Exit Sub
    If Len(strAdd5) <> 0 Then AddToString strAdd5 Else Exit Sub
End Sub
