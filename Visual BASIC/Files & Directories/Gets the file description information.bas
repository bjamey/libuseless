' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Gets the file description information
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetFileDescription
'
' Gets the file description information.
'
' IN: [strFilename] - name of file to get description of.
'
' Returns: Description (vbNullString if not found)
'-----------------------------------------------------------
'
Function GetFileDescription(ByVal sFile As String) As String
    Dim lVerSize As Long, lTemp As Long, lRet As Long
    Dim bInfo() As Byte
    Dim lpBuffer As Long
    Dim sDesc As String
    Dim sKEY As String
    Const sEXE As String = "\FileDescription"

    GetFileDescription = vbNullString

    '
    'Get the size of the file version info, allocate a buffer for it, and get the
    'version info.  Next, we query the Fixed file info portion, where the internal
    'file version used by the Windows VerInstallFile API is kept.  We then copy
    'the info into a string.
    '
    lVerSize = GetFileVersionInfoSize(sFile, lTemp)
    ReDim bInfo(lVerSize)
    If lVerSize > 0 Then
        lRet = GetFileVersionInfo(sFile, lTemp, lVerSize, VarPtr(bInfo(0)))
        If lRet <> 0 Then
            sKEY = GetNLSKey(bInfo)
            lRet = VerQueryValue(VarPtr(bInfo(0)), sKEY & sEXE, lpBuffer, lVerSize)
            If lRet <> 0 Then
                sDesc = Space$(lVerSize)
                lstrcpyn sDesc, lpBuffer, lVerSize
                GetFileDescription = sDesc
            End If
        End If
    End If
End Function
Private Function GetNLSKey(byteVerData() As Byte) As String
    Const strTRANSLATION$ = "\VarFileInfo\Translation"
    Const strSTRINGFILEINFO$ = "\StringFileInfo\"
    Const strDEFAULTNLSKEY$ = "040904E4"
    Const LOCALE_IDEFAULTLANGUAGE& = &H9&
    Const LOCALE_IDEFAULTCODEPAGE& = &HB&

    Static strLANGCP As String

    Dim lpBufPtr As Long
    Dim strNLSKey As String
    Dim fGotNLSKey As Integer
    Dim intOffset As Integer
    Dim lVerSize As Long
    Dim ltmp As Long
    Dim lBufLen As Long
    Dim lLCID As Long
    Dim strTmp As String

    On Error GoTo GNLSKCleanup

    If VerQueryValue(VarPtr(byteVerData(0)), strTRANSLATION, lpBufPtr, lVerSize) <> 0 Then ' (Pass byteVerData array via reference to first element)
        If Len(strLANGCP) = 0 Then
            lLCID = GetUserDefaultLCID()
            If lLCID > 0 Then
                strTmp = Space$(8)

                GetLocaleInfoA lLCID, LOCALE_IDEFAULTCODEPAGE, strTmp, 8
                strLANGCP = StripTerminator(strTmp)
                While Len(strLANGCP) < 4
                    strLANGCP = gsZERO & strLANGCP
                Wend

                GetLocaleInfoA lLCID, LOCALE_IDEFAULTLANGUAGE, strTmp, 8
                strLANGCP = StripTerminator(strTmp) & strLANGCP
                While Len(strLANGCP) < 8
                    strLANGCP = gsZERO & strLANGCP
                Wend
            End If
        End If

        If VerQueryValue(VarPtr(byteVerData(0)), strLANGCP, ltmp, lBufLen) <> 0 Then
            strNLSKey = strLANGCP
        Else
            For intOffset = 0 To lVerSize - 1 Step 4
                CopyMemory ltmp, ByVal lpBufPtr + intOffset, 4
                strTmp = Hex$(ltmp)
                While Len(strTmp) < 8
                    strTmp = gsZERO & strTmp
                Wend

                strNLSKey = strSTRINGFILEINFO & Right$(strTmp, 4) & Left$(strTmp, 4)

                If VerQueryValue(VarPtr(byteVerData(0)), strNLSKey, ltmp, lBufLen) <> 0 Then
                    fGotNLSKey = True
                    Exit For
                End If
            Next

            If Not fGotNLSKey Then
                strNLSKey = strSTRINGFILEINFO & strDEFAULTNLSKEY
                If VerQueryValue(VarPtr(byteVerData(0)), strNLSKey, ltmp, lBufLen) <> 0 Then
                    fGotNLSKey = True
                End If
            End If
        End If
    End If

GNLSKCleanup:
    If fGotNLSKey Then
        GetNLSKey = strNLSKey
    End If
End Function
