' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Convert Bytes to KB
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit


' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function StrFormatByteSize Lib "shlwapi" Alias "StrFormatByteSizeA" (ByVal dw As Long, ByVal pszBuf As String, ByRef cchBuf As Long) As String

' ---------------
' Function
' ---------------

Public Function FormatKB(ByVal Amount As Long) As String
    Dim Buffer As String
    Dim Result As String
    Buffer = Space$(255)
    Result = StrFormatByteSize(Amount, Buffer, Len(Buffer))

    If InStr(Result, vbNullChar) > 1 Then
        FormatKB = Left$(Result, InStr(Result, vbNullChar) - 1)
    End If
End Function
