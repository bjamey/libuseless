' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Format Memory Size
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Enum FormatMemorySizeUnits
    BestGuess
    Bytes
    Kilobytes
    Megabytes
    Gigabytes
End Enum


' convert a number of bytes into Kbytes, Megabytes, or Gigabytes

Function FormatMemorySize(ByVal value As Long, _
    ByVal unit As FormatMemorySizeUnits, Optional ByVal decimalDigits As _
    Integer = 2, Optional ByVal omitThousandSeps As Boolean = False) As String
    ' simple error checking
    If value < 0 Then Throw New ArgumentException("Value can't be negative")

    ' get the best unit, if required
    If unit = FormatMemorySizeUnits.BestGuess Then
        Select Case value
            Case Is < 1023
                unit = FormatMemorySizeUnits.Bytes
                decimalDigits = 0
            Case Is < 1024 * 1023
                unit = FormatMemorySizeUnits.Kilobytes
            Case Is < 1048576 * 1023
                unit = FormatMemorySizeUnits.Megabytes
            Case Else
                unit = FormatMemorySizeUnits.Gigabytes
        End Select
    End If

    ' evaluate the decimal value
    Dim val As Decimal
    Dim suffix As String

    Select Case unit
        Case FormatMemorySizeUnits.Bytes
            val = value
        Case FormatMemorySizeUnits.Kilobytes
            val = value / 1024
            suffix = "K"
        Case FormatMemorySizeUnits.Megabytes
            val = value / 1048576
            suffix = "M"
        Case FormatMemorySizeUnits.Gigabytes
            val = value / 1073741824
            suffix = "G"
    End Select

    ' get the string representation
    Dim format As String
    If omitThousandSeps Then
        format = "F" & decimalDigits.ToString
    Else
        format = "N" & decimalDigits.ToString
    End If

    Return val.ToString(format) & suffix
End Function

