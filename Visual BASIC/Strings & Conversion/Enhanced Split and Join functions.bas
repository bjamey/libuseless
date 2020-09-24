' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Enhanced Split and Join functions
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------
'
'   Module          : modStrings
'   Description     : String Utility Functions
'   Author          : Quick VB
'   Last Updated    : 15th April, 2000.
'   Notes           : Functions may be slower esp., SplitString compared to Split function
'                     But, you do need to sacrifice performance for added functionality.
'                     Compile these functions into a Global Multiuse Class module in your ActiveX DLL.
'
'                     Requires IE 4.0 or later to be installed in order to work. (StrBPrk function)
'
'   Copyright Info  :
'
'   This module is provided AS-IS. This module can be used as a part of a compiled
'   executable whether freeware or not. This module may not be posted to any web site
'   or BBS or any redistributable media like CD-ROM without the consent of the author.
'
'   web site : http://www.quickvb.com/
'
'   e-mail   : esanthosh@quickvb.com
'
'   Revision History :
'
'
'-------------------------------------------------------------------------------------------------------------

Option Explicit

'
' API Declarations
'
Private Declare Function StrCSpnI Lib "shlwapi" Alias "StrCSpnIA" _
                                  (ByVal StringSearched As String, ByVal Characters As String) As Long


'
' Enums
'
Public Enum PadType
    padLeft
    padCenter
    padRight
End Enum

Public Function SplitString(ByVal toSplit As String, _
                            Optional ByVal SplitChars As String = " ", _
                            Optional ByVal EscapeChar As String = "\", _
                            Optional ByVal TrimStrings As Boolean = True) _
                            As String()

    '--------------------------------------------------------------------------------------------------
    ' Arguments :
    '
    ' toSplit               - String to be Splitted
    ' SplitChars            - Delimiters that are used for Splitting the String (Default : Space)
    ' EscapeChar            - The Escape Character (if precedes a Split Character, the Split
    '                         Character is recognized as a literal) (Default : Back Slash)
    ' TrimStrings           - If True, trims the returned Strings in the Array, else the spaces are
    '                         returned as-is.
    '
    ' Returns   : The Splitted String Array
    '
    '
    ' Notes     :  This function is slower than the Split() counterpart. It's slows down as the length of the
    '              string increases. But, it provides you two things that Split() does not provide.
    '              1. It allows multiple delimiters (called SplitChars here)
    '              2. What if you want to represent the delimiter itself ? For e.g., if you have
    '                 - as the delimiter and you want to pass A-B as an argument ?. For this, this function
    '                allows you to have one Escape Character. Instead of passing A-B, you pass the argument as
    '               A\-B in this case.
    '
    '--------------------------------------------------------------------------------------------------

    Dim retArray() As String        ' The returned array of results
    Dim tempString As String        ' The Temporary Buffer
    Dim arrLength As Long           ' No. Of Splitted Parts
    Dim isEscapeChar As Boolean     ' Was a Escape Character found ?
    Dim FoundPos As Long            ' The position at which the Split Character was found

    ReDim retArray(0 To 0)          ' Hmm.. Looks like bad example of Initializing an array
    arrLength = -1                  ' No of split parts - 1

    If EscapeChar <> "" Then
        EscapeChar = Left$(EscapeChar, 1)   ' Only one character can be allowed as the EscapeCharacter
    End If

    If Len(toSplit) = 0 Then       ' No String, nothing to do ...
        SplitString = retArray
        Exit Function
    End If

    If Len(SplitChars) = 0 Then     ' No Splitting to be done
        SplitString = retArray
        Exit Function
    End If

    '
    ' To avoid Redimensioning Array many times within the loop, we dimension the array to the
    ' maximum possible extent and waste some memory
    '
    ReDim retArray(0 To 10)

    toSplit = toSplit & Chr$(0)
    SplitChars = SplitChars & Chr$(0)

    Do
        ' Use the SHLWAPI function to search for String matches
        FoundPos = StrCSpnI(toSplit, SplitChars)

        '
        ' The String before the Split Character (if any) should be "splitted"
        ' unless there is a Escape Character preceding the Split Character
        '
        FoundPos = FoundPos + 1     ' Remember ? C Strings start with a Zero Index

        Select Case FoundPos
            Case Len(toSplit), 0
                arrLength = arrLength + 1

                If arrLength > UBound(retArray) Then
                    ReDim Preserve retArray(arrLength + 5)  ' Pre-Allocate more memory
                End If

                If isEscapeChar Then
                    retArray(arrLength) = tempString & toSplit    ' Whatever is remaining
                Else
                    retArray(arrLength) = toSplit
                End If

                If TrimStrings Then retArray(arrLength) = Trim$(retArray(arrLength))
                Exit Do

            Case Is > 1
                ' Check for Escape Character
                If Mid$(toSplit, FoundPos - 1, 1) = EscapeChar Then
                    ' The Split Character is intepreted as an ordinary literal.
                    isEscapeChar = True

                    ' Remove everything before the Escape Character for temporary storage
                    If Len(toSplit) > 2 Then
                        tempString = Left$(toSplit, FoundPos - 2) & Mid$(toSplit, FoundPos, 1)
                    Else        ' The Escape Character is the First Character
                        tempString = Mid$(toSplit, FoundPos)
                    End If

                    ' To avoid "finding" the Escaped Split Character again, we rip that part
                    If Len(toSplit) > FoundPos + 1 Then
                        toSplit = Mid$(toSplit, FoundPos + 1)
                    Else
                        ' The String has ended with the Escaped Split Character. Now
                        ' this is the last part of the string that must be stored in the
                        ' Split Array. Just do that !
                        arrLength = arrLength + 1

                        If arrLength > UBound(retArray) Then
                            ReDim Preserve retArray(arrLength + 5)  ' Pre-Allocate more memory
                        End If

                        retArray(arrLength) = tempString
                        If TrimStrings Then retArray(arrLength) = Trim$(retArray(arrLength))
                        Exit Do
                    End If

                Else        ' No Escape Character
                    arrLength = arrLength + 1

                    If arrLength > UBound(retArray) Then
                        ReDim Preserve retArray(arrLength + 5)  ' Pre-Allocate more memory
                    End If

                    ' We might have left-overs of an Escaped Split Character
                    If isEscapeChar Then
                        retArray(arrLength) = tempString & Left$(toSplit, FoundPos - 1)
                        isEscapeChar = False
                    Else
                        retArray(arrLength) = Left$(toSplit, FoundPos - 1)
                    End If

                    If TrimStrings Then retArray(arrLength) = Trim$(retArray(arrLength))

                    ' Remove that Part
                    If Len(toSplit) > FoundPos + 1 Then
                        toSplit = Mid$(toSplit, FoundPos + 1)
                    Else
                        ' No more string to be splitted. Re-dimenstion the array.
                        Exit Do
                    End If
                End If

            Case 1
                ' The Split Character is at the First Position
                If Len(toSplit) > 1 Then
                    toSplit = Mid$(toSplit, 2)
                Else
                    Exit Do
                End If
        End Select
    Loop

    ReDim Preserve retArray(arrLength)
    toSplit = ""

    SplitString = retArray

End Function

Public Function Pad(ByVal argString As String, ByVal TotalLength As Long, _
                    Optional ByVal Direction As PadType = padCenter, _
                    Optional ByVal PadCharacter As String = " ") As String
    '
    ' Pads a String using another string to the specified length (Memories of XBase ?)
    '

    If argString = "" Then Exit Function

    If TotalLength <= Len(argString) Then
        Pad = Left$(argString, TotalLength)
        Exit Function
    End If

    PadCharacter = Left$(PadCharacter, 1)

    If Direction = padCenter Then
        PadCharacter = String$((TotalLength - Len(argString)) \ 2, PadCharacter)
    Else
        PadCharacter = String$(TotalLength - Len(argString), PadCharacter)
    End If

    Select Case Direction
        Case padLeft
            Pad = PadCharacter & argString

        Case padRight
            Pad = argString & PadCharacter

        Case Else
            Pad = PadCharacter & argString & PadCharacter
            If Len(Pad) < TotalLength Then
                Pad = Space$(TotalLength - Len(Pad)) & Pad
            End If
    End Select
End Function

Public Function JoinString(StringIn() As String, _
                           ByVal JoinCharacter As String, Optional ByVal EscapeChar As String = "\") As String

    '-----------------------------------------------------------------------------------------
    ' Arguments :  StringIn      - Array of Strings to be joined
    '              JoinCharacter - Character used for joining strings in the array
    '              EscapeChar    - If the Escape Character or Join Character is found in a string
    '                              it is preceded by the EscapeChar. The resulting string can be
    '                              used with the SplitStrting Function.
    '
    ' Returns    : The joined String
    '
    ' Comments   : Ever tried to Join the Strings "a","b","c,d" using Comma as the delimiter ?
    '              You don't have to figure out which is the delimiter and which comma is the
    '              literal. With JoinString(), you always know what you are getting.
    '
    '-----------------------------------------------------------------------------------------

    Dim I As Long, LastPos As Long

    ' Argument validation
    If EscapeChar = "" Then EscapeChar = "\"
    If JoinCharacter = "" Then JoinCharacter = " "
    If Len(JoinCharacter) > 1 Then JoinCharacter = Left$(JoinCharacter, 1)

    For I = LBound(StringIn) To UBound(StringIn)
        If InStr(1, StringIn(I), JoinCharacter, vbTextCompare) > 0 Then
            StringIn(I) = Replace(StringIn(I), JoinCharacter, EscapeChar & JoinCharacter, 1, -1, vbTextCompare)
        End If

        ' Join 'em
        JoinString = JoinString & StringIn(I) & JoinCharacter
    Next


    ' Remove the last Join Character
    JoinString = Left$(JoinString, Len(JoinString) - 1)

End Function
