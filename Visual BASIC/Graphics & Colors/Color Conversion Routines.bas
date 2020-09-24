' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Color Conversion Routines
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

Private RGBs() As String
Private Const HSLMAX As Integer = 240
    'H, S and L values can be 0 - HSLMAX
    '240 matches what is used by MS Win;
    'any number less than 1 byte is OK;
    'works best if it is evenly divisible by 6
Private Const RGBMAX As Integer = 255     ' R, G, and B value can be 0 - RGBMAX
Private Const UNDEFINED As Integer = (HSLMAX * 2 \ 3)     ' Hue is undefined if Saturation = 0 (greyscale)

' ======================================================================== '
Public Function LongToRGB(Value As Long, Optional ChooseDelimiter As String = ",") As String
    On Error Resume Next

    Dim Blue As Double, Green As Double, Red As Double
    Dim BlueS As Double, GreenS As Double, RGBs As String

    Blue = Abs(Fix((Value / 256) / 256))
    BlueS = (Blue * 256) * 256
    Green = Abs(Fix((Value - BlueS) / 256))
    GreenS = Green * 256
    Red = Abs(Fix(Value - BlueS - GreenS))
    RGBs = (Red & ChooseDelimiter & Green & ChooseDelimiter & Blue)
    LongToRGB = RGBs
End Function

' ======================================================================== '

Public Function RGBToHex2(R As Long, g As Long, B As Long) As String
    On Error Resume Next

    Dim sR As String, sG As String, sB As String

    sR = Hex$(R)
    sG = Hex$(g)
    sB = Hex$(B)

    If sR = "0" Then sR = "00"
    If sG = "0" Then sG = "00"
    If sB = "0" Then sB = "00"

    RGBToHex2 = sR & sG & sB
End Function

' ======================================================================== '

Public Function RGBToHex(RGBValue As String, Optional delimiter As String = ",") As String
    On Error Resume Next

    Dim PartHexValue(2) As String, FullHexValue As String, i As Long

    RGBs() = Split(RGBValue, delimiter)

    Do While i <= 2
        PartHexValue(i) = Hex$(Trim$(RGBs(i)))
        If PartHexValue(i) = "0" Then PartHexValue(i) = "00"
        If Len(PartHexValue(i)) <> 2 Then PartHexValue(i) = "0" & PartHexValue(i)
        FullHexValue = FullHexValue & PartHexValue(i)

        i = i + 1
    Loop

    RGBToHex = FullHexValue
End Function

' ======================================================================== '

Public Function HexToRGB(ByVal HexValue As String) As String
    On Error Resume Next

    If AscW(HexValue) = 35 Then HexValue = Right$(HexValue, Len(HexValue) - 1)
'    If Left$(HexValue, 1) = "#" Then
    Dim RGBValue(2) As Long

    RGBValue(0) = CLng((GetHexValue(Mid$(HexValue, 1, 1))) * 16 + (GetHexValue(Mid$(HexValue, 2, 1))))
    RGBValue(1) = CLng((GetHexValue(Mid$(HexValue, 3, 1))) * 16 + (GetHexValue(Mid$(HexValue, 4, 1))))
    RGBValue(2) = CLng((GetHexValue(Mid$(HexValue, 5, 1))) * 16 + (GetHexValue(Mid$(HexValue, 6, 1))))

    HexToRGB = "RGB(" & RGBValue(0) & ", " & RGBValue(1) & ", " & RGBValue(2) & ")"
End Function

' ======================================================================== '

Public Function ShortHexToLong(ByVal HexValue As String) As Long
    On Error Resume Next

    If AscW(HexValue) = 35 Then HexValue = Right$(HexValue, Len(HexValue) - 1)
'    If Left$(HexValue, 1) = "#" Then
    Dim RGBValue(2) As Long

    RGBValue(0) = CLng((GetHexValue(Mid$(HexValue, 1, 1))) * 16)    ' + (GetHexValue(Mid$(HexValue, 2, 1))))
    RGBValue(1) = CLng((GetHexValue(Mid$(HexValue, 2, 1))) * 16)    ' + (GetHexValue(Mid$(HexValue, 4, 1))))
    RGBValue(2) = CLng((GetHexValue(Mid$(HexValue, 3, 1))) * 16)    ' + (GetHexValue(Mid$(HexValue, 6, 1))))

    ShortHexToLong = RGB(RGBValue(0), RGBValue(1), RGBValue(2))
End Function

' ======================================================================== '

Public Function GetHexValue(HexChar As String) As String
    On Error Resume Next

    Dim a As Integer
    a = AscW(UCase$(HexChar))

    Select Case a
        Case 65 To 70       ' "A" To "F"
            GetHexValue = CStr(10 + (a - 65))
        Case 48 To 57       ' 0 To 9
            GetHexValue = HexChar
        Case Else
            GetHexValue = 0
    End Select
End Function

' ======================================================================== '

Public Function LongToHex(LongValue As Long, Optional ByVal bIncludeSign As Boolean = True) As String
    On Error Resume Next

    Dim Pad As Integer, ColorCode As String

    ColorCode = Hex$(LongValue)    ' convert to hex

    Pad = 6 - Len(ColorCode)    ' determine how many zeros to pad in front of converted value

    If Pad > 0 Then ColorCode = String$(Pad, "0") & ColorCode
    ColorCode = Right$(ColorCode, 2) & Mid$(ColorCode, 3, 2) & left$(ColorCode, 2)      ' convert to hex

    If bIncludeSign Then LongToHex = "#" & ColorCode Else LongToHex = ColorCode
End Function

' ======================================================================== '

Public Function iMax(a As Integer, B As Integer) As Integer
    ' Return the Larger of two values
    If a > B Then iMax = a Else iMax = B
End Function

' ======================================================================== '

Public Function iMin(a As Integer, B As Integer) As Integer
    ' Return the smaller of two values
    If a < B Then iMin = a Else iMin = B
End Function

' ======================================================================== '

Public Function RgbToHSL(ByVal R As Long, ByVal g As Long, ByVal B As Long) As String
    On Error Resume Next

    Dim cMax As Integer, cMin As Integer
    Dim RDelta As Double, GDelta As Double, BDelta As Double
    Dim H As Double, s As Double, l As Double
    Dim cMinus As Long, cPlus As Long

    cMax = iMax(iMax(CInt(R), CInt(g)), CInt(B))   'Highest and lowest
    cMin = iMin(iMin(CInt(R), CInt(g)), CInt(B)) 'color values

    cMinus = cMax - cMin ' Used To simplify the
    cPlus = cMax + cMin ' calculations somewhat.

    ' Calculate luminescence (lightness)
    l = ((cPlus * HSLMAX) + RGBMAX) / (2 * RGBMAX)

    If cMax = cMin Then ' achromatic (r=g=b, greyscale)
        s = 0 ' Saturation 0 For greyscale
        H = UNDEFINED ' Hue undefined For greyscale
    Else
        ' Calculate color saturation
        If l <= (HSLMAX / 2) Then
            s = ((cMinus * HSLMAX) + 0.5) / cPlus
        Else
            s = ((cMinus * HSLMAX) + 0.5) / (2 * RGBMAX - cPlus)
        End If

        ' Calculate hue
        RDelta = (((cMax - R) * (HSLMAX / 6)) + 0.5) / cMinus
        GDelta = (((cMax - g) * (HSLMAX / 6)) + 0.5) / cMinus
        BDelta = (((cMax - B) * (HSLMAX / 6)) + 0.5) / cMinus


        Select Case cMax
            Case CLng(R)
                H = BDelta - GDelta
            Case CLng(g)
                H = (HSLMAX / 3) + RDelta - BDelta
            Case CLng(B)
                H = ((2 * HSLMAX) / 3) + GDelta - RDelta
        End Select

        If H < 0 Then H = H + HSLMAX
    End If

    RgbToHSL = H & " " & s & " " & l
End Function

' ======================================================================== '

Public Function HSLtoRGB(ByRef H As Double, ByRef s As Double, ByRef l As Double) As String
    On Error Resume Next

    Dim R As Double, g As Double, B As Double
    Dim Magic1 As Double, Magic2 As Double

    If CInt(s) = 0 Then 'Greyscale
        R = (l * RGBMAX) / HSLMAX 'luminescence,
                'converted to the proper range
        g = R 'All RGB values same in greyscale
        B = R
'        If CInt(H) <> UNDEFINED Then
'            'This is technically an error.
'            'The RGBtoHSL routine will always return
'            'Hue = UNDEFINED (160 when HSLMAX is 240)
'            'when Sat = 0.
'            'if you are writing a color mixer and
'            'letting the user input color values,
'            'you may want to set Hue = UNDEFINED
'            'in this case.
'        End If
    Else
        'Get the "Magic Numbers"
        If l <= HSLMAX / 2 Then
            Magic2 = (l * (HSLMAX + s) + 0.5) / HSLMAX
        Else
            Magic2 = l + s - ((l * s) + 0.5) / HSLMAX
        End If

        Magic1 = 2 * l - Magic2

        ' Get R, G, B; change units from HSLMAX range
        ' to RGBMAX range
        R = (HueToRGB(Magic1, Magic2, H + (HSLMAX / 3)) * RGBMAX + 0.5) / HSLMAX
        g = (HueToRGB(Magic1, Magic2, H) * RGBMAX + 0.5) / HSLMAX
        B = (HueToRGB(Magic1, Magic2, H - (HSLMAX / 3)) * RGBMAX + 0.5) / HSLMAX
    End If

    H = R: s = g: l = B
    HSLtoRGB = "RGB(" & CInt(R) & ", " & CInt(g) & ", " & CInt(B) & ")"
End Function

' ======================================================================== '

Private Function HueToRGB(Mag1 As Double, Mag2 As Double, ByVal Hue As Double) As Double
    On Error Resume Next

    ' Utility function for HSLtoRGB

    ' Range check
    If Hue < 0 Then
        Hue = Hue + HSLMAX
    ElseIf Hue > HSLMAX Then
        Hue = Hue - HSLMAX
    End If

    'Return r, g, or b value from parameters
    Select Case Hue 'Values get progressively larger.
                'Only the first true condition will execute
        Case Is < (HSLMAX / 6)
            HueToRGB = (Mag1 + (((Mag2 - Mag1) * Hue + (HSLMAX / 12)) / (HSLMAX / 6)))
        Case Is < (HSLMAX / 2)
            HueToRGB = Mag2
        Case Is < (HSLMAX * 2 / 3)
            HueToRGB = (Mag1 + (((Mag2 - Mag1) * ((HSLMAX * 2 / 3) - Hue) + (HSLMAX / 12)) / (HSLMAX / 6)))
        Case Else
            HueToRGB = Mag1
    End Select
End Function

' ======================================================================== '

Public Function Brighten(ByRef R As Long, ByRef g As Long, ByRef B As Long, Optional Percent As Single = 0.07)
    On Error Resume Next

    ' Lightens the color by a specifie percent, given as a Single (10% = .10)
    Dim H As Double, s As Double, l As Double, HSL As String, sTmp() As String

    If Percent <= 0 Then Exit Function

    HSL = RgbToHSL(R, g, B)
    sTmp = Split(HSL)
    H = CDbl(sTmp(0))
    s = CDbl(sTmp(1))
    l = CDbl(sTmp(2)) + (HSLMAX * Percent)
    If l > HSLMAX Then l = HSLMAX
    Call HSLtoRGB(H, s, l)
    R = H: g = s: B = l
End Function

' ======================================================================== '

Public Function Darken(ByRef R As Long, ByRef g As Long, ByRef B As Long, Optional Percent As Single = 0.07)
    ' Darkens the color by a specifie percent, given as a Single
    On Error Resume Next
    Dim H As Double, s As Double, l As Double, HSL As String, sArray() As String

    If Percent <= 0 Then Exit Function

    HSL = RgbToHSL(R, g, B)
    sArray = Split(HSL)
    H = CDbl(sArray(0))
    s = CDbl(sArray(1))
    l = CDbl(sArray(2)) - (HSLMAX * Percent)
    If l < 0 Then l = 0
    Call HSLtoRGB(H, s, l)
    R = H: g = s: B = l
End Function

' ======================================================================== '
