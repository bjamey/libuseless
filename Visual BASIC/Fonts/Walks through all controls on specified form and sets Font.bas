' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Walks through all controls on specified form and sets Font; a font
'         chosen according to the system locale
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' SUB: SetFormFont
'
' Walks through all controls on specified form and
' sets Font a font chosen according to the system locale
'
' IN: [frm] - Form whose control fonts need to be set.
'-----------------------------------------------------------
'
Public Sub SetFormFont(frm As Form)
    Dim ctl As Control
    Dim fntSize As Integer
    Dim fntName As String
    Dim fntCharset As Integer
    Dim oFont As StdFont

    ' some controls may fail, so we will do a resume next...
    '
    On Error Resume Next

    ' get the font name, size, and charset
    '
    GetFontInfo fntName, fntSize, fntCharset

    'Create a new font object
    Set oFont = New StdFont
    With oFont
        .Name = fntName
        .Size = fntSize
        .Charset = fntCharset
    End With
    ' Set the form's font
    Set frm.Font = oFont
    '
    ' loop through each control and try to set its font property
    ' this may fail, but our error handling is shut off
    '
    For Each ctl In frm.Controls
        Set ctl.Font = oFont
    Next
    '
    ' get out, reset error handling
    '
    Set ctl = Nothing
    On Error GoTo 0
    Exit Sub

End Sub

'-----------------------------------------------------------
' SUB:  GetFontInfo
'
' Gets the best font to use according the current system's
' locale.
'
' OUT:  [sFont] - name of font
'       [nFont] - size of font
'       [nCharset] - character set of font to use
'-----------------------------------------------------------
Private Sub GetFontInfo(sFont As String, nFont As Integer, nCharSet As Integer)
    Dim LCID    As Integer
    Dim PLangId As Integer
    Dim sLangId As Integer
    ' if font is set, used the cached values
    If m_sFont <> "" Then
        sFont = m_sFont
        nFont = m_nFont
        nCharSet = m_nCharset
        Exit Sub
    End If

    ' font hasn't been set yet, need to get it now...
    LCID = GetSystemDefaultLCID                 ' get current system LCID
    PLangId = PRIMARYLANGID(LCID)               ' get LCID's Primary language id
    sLangId = SUBLANGID(LCID)                   ' get LCID's Sub language id

    Select Case PLangId                         ' determine primary language id
    Case LANG_CHINESE
        If (sLangId = SUBLANG_CHINESE_TRADITIONAL) Then
            sFont = ChrW$(&H65B0) & ChrW$(&H7D30) & ChrW$(&H660E) & ChrW$(&H9AD4)   ' New Ming-Li
            nFont = 9
            nCharSet = CHARSET_CHINESEBIG5
        ElseIf (sLangId = SUBLANG_CHINESE_SIMPLIFIED) Then
            sFont = ChrW$(&H5B8B) & ChrW$(&H4F53)
            nFont = 9
            nCharSet = CHARSET_CHINESESIMPLIFIED
        End If
    Case LANG_JAPANESE
        sFont = ChrW$(&HFF2D) & ChrW$(&HFF33) & ChrW$(&H20) & ChrW$(&HFF30) & _
                ChrW$(&H30B4) & ChrW$(&H30B7) & ChrW$(&H30C3) & ChrW$(&H30AF)
        nFont = 9
        nCharSet = CHARSET_SHIFTJIS
    Case LANG_KOREAN
        If (sLangId = SUBLANG_KOREAN) Then
            sFont = ChrW$(&HAD74) & ChrW$(&HB9BC)
        ElseIf (sLangId = SUBLANG_KOREAN_JOHAB) Then
            sFont = ChrW$(&HAD74) & ChrW$(&HB9BC)
        End If
        nFont = 9
        nCharSet = CHARSET_HANGEUL
    Case Else
        sFont = "Tahoma"
        If Not IsFontSupported(sFont) Then
            'Tahoma is not on this machine.  This condition is very probably since
            'this is a setup program that may be run on a clean machine
            'Try Arial
            sFont = "Arial"
            If Not IsFontSupported(sFont) Then
                'Arial isn't even on the machine.  This is an unusual situation that
                'is caused by deliberate removal
                'Try system
                sFont = "System"
                'If system isn't supported, allow the default font to be used
                If Not IsFontSupported(sFont) Then
                    'If "System" is not supported, "IsFontSupported" will have
                    'output the default font in sFont
                End If
            End If
        End If
        nFont = 8
        ' set the charset for the users default system Locale
        nCharSet = GetUserCharset
    End Select
    m_sFont = sFont
    m_nFont = nFont
    m_nCharset = nCharSet
'-------------------------------------------------------
End Sub
'-------------------------------------------------------


'------------------------------------------------------------
'- Language Functions...
'------------------------------------------------------------
Private Function PRIMARYLANGID(ByVal LCID As Integer) As Integer
    PRIMARYLANGID = (LCID And &H3FF)
End Function
Private Function SUBLANGID(ByVal LCID As Integer) As Integer
    SUBLANGID = (LCID / (2 ^ 10))
End Function

'-----------------------------------------------------------
' Function: GetUserCharset
'
' Get's the default user character set
'
' OS: Win 95 & NT 4 or newer
'-----------------------------------------------------------
Private Function GetUserCharset() As Integer
    Dim ls  As LOCALESIGNATURE                              ' local signature struct.
    Dim ci  As CHARSETINFO                                  ' character set info struct.
    Dim rc  As Long                                         ' return code
    ' get locale signature based on the USER's Default LCID.
    rc = GetLocaleInfoLS(GetUserDefaultLCID, LOCALE_FONTSIGNATURE, ls, Len(ls))
    If (rc > 0) Then                                        ' if success
        ls.lsCsbDefault(1) = 0                              ' zero out bits

        ' translate charset info from locale fontsignature.
        rc = TranslateCharsetInfo(ls.lsCsbDefault(0), ci, TCI_SRCFONTSIG)
        If rc <> 0 Then GetUserCharset = ci.ciCharset       ' return charset
    End If
End Function

'-----------------------------------------------------------
' Function: IsFontSupported
'
' Validates a font name to make sure it is supported by
' on the current system.
'
' IN/OUT: [sFontName] - name of font to check, will also]
'         be set to the default font name if the provided
'         one is not supported.
'-----------------------------------------------------------
Private Function IsFontSupported(sFontName As String) As Boolean
    Dim oFont As StdFont
    On Error Resume Next
    Set oFont = New StdFont
    oFont.Name = sFontName
    IsFontSupported = (UCase(oFont.Name) = UCase(sFontName))
    sFontName = oFont.Name
End Function
