' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Reads the allowable protocols from the specified file
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: ReadProtocols
' Reads the allowable protocols from the specified file.
'
' IN: [strInputFilename] - INI filename from which to read the protocols
'     [strINISection] - Name of the INI section
'-----------------------------------------------------------
Function ReadProtocols(ByVal strInputFilename As String, ByVal strINISection As String) As Boolean
    Dim intIdx As Integer
    Dim fOk As Boolean
    Dim strInfo As String
    Dim intOffset As Integer

    intIdx = 0
    fOk = True
    Erase gProtocol
    gcProtocols = 0

    Do
        strInfo = ReadIniFile(strInputFilename, strINISection, gstrINI_PROTOCOL & Format$(intIdx + 1))
        If strInfo <> vbNullString Then
            intOffset = InStr(strInfo, gstrCOMMA)
            If intOffset > 0 Then
                'The "ugly" name will be first on the line
                ReDim Preserve gProtocol(intIdx + 1)
                gcProtocols = intIdx + 1
                gProtocol(intIdx + 1).strName = Left$(strInfo, intOffset - 1)

                '... followed by the friendly name
                gProtocol(intIdx + 1).strFriendlyName = Mid$(strInfo, intOffset + 1)
                If (gProtocol(intIdx + 1).strName = "") Or (gProtocol(intIdx + 1).strFriendlyName = "") Then
                    fOk = False
                End If
            Else
                fOk = False
            End If

            If Not fOk Then
                Exit Do
            Else
                intIdx = intIdx + 1
            End If
        End If
    Loop While strInfo <> vbNullString

    ReadProtocols = fOk
End Function
