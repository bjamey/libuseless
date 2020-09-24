' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Generate GUID using the CoCreateGuid API
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Public Type GUID
    Data1 As Long
    Data2 As Integer
    Data3 As Integer
    Data4(7) As Byte
End Type

Public Declare Function CoCreateGuid Lib "OLE32.DLL" (pGuid As GUID) As Long
Public Const S_OK = 0 ' return value from CoCreateGuid


' ---------
' Function
' ---------

Function GetGUID() As String
    Dim lResult As Long
    Dim lguid As GUID
    Dim MyguidString As String
    Dim MyGuidString1 As String
    Dim MyGuidString2 As String
    Dim MyGuidString3 As String
    Dim DataLen As Integer
    Dim StringLen As Integer
    Dim i%

    On Error GoTo error_olemsg

    lResult = CoCreateGuid(lguid)

    If lResult = S_OK Then
        MyGuidString1 = Hex$(lguid.Data1)
        StringLen = Len(MyGuidString1)
        DataLen = Len(lguid.Data1)
        MyGuidString1 = LeadingZeros(2 * DataLen, StringLen) & MyGuidString1        'First 4 bytes (8 hex digits)

        MyGuidString2 = Hex$(lguid.Data2)
        StringLen = Len(MyGuidString2)
        DataLen = Len(lguid.Data2)
        MyGuidString2 = LeadingZeros(2 * DataLen, StringLen) & Trim$(MyGuidString2)        'Next 2 bytes (4 hex digits)

        MyGuidString3 = Hex$(lguid.Data3)
        StringLen = Len(MyGuidString3)
        DataLen = Len(lguid.Data3)
        MyGuidString3 = LeadingZeros(2 * DataLen, StringLen) & Trim$(MyGuidString3)        'Next 2 bytes (4 hex digits)

        GetGUID = MyGuidString1 & MyGuidString2 & MyGuidString3

        For i% = 0 To 7
           MyguidString = MyguidString & Format$(Hex$(lguid.Data4(i%)), "00")
        Next i%

        'MyGuidString contains last 8 bytes of Guid (16 hex digits)
        GetGUID = GetGUID & MyguidString
    Else
        GetGUID = "00000000" ' return zeros if function unsuccessful
    End If

    Exit Function

error_olemsg:
         MsgBox "Error " & Str(Err) & ": " & Error$(Err)
         GetGUID = "00000000"
         Exit Function

End Function

' =============================================================== '

Function LeadingZeros(ExpectedLen As Integer, ActualLen As Integer) As String
    LeadingZeros = String$(ExpectedLen - ActualLen, "0")
End Function
