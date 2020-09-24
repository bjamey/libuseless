' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Comprehensive e-mail address syntax validation check
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ------------------------------------------------------ '
' Purpose: Validate a given e-mail address.
' In:           strAddress - string to be validated
' Out:
' Returns: True if strAddress is a valid e-mail address; False otherwise.
' Date: 8/23/1999
' Programmer: Ian Lent and Melvin Tucker
' ------------------------------------------------------ '

Public Function ValidateEmail(ByVal strAddress As String) As Boolean
    Dim lngIndex As Long            ' Position in strAddress
    Dim lngCountAt As Long          ' Number of "@"
    Dim lngLastDotPos As Long       ' Position of the previous dot in the string
    Dim strCurrentChar As String    ' Buffer that holds the contents of the string one char at a time.

    On Error GoTo Fail_Validation

    ValidateEMail = True            ' Prove me wrong!
    strAddress = Trim(strAddress)
    lngLastDotPos = 0
    lngCountAt = 0

    ' If the address isn't at least this (a@b.com) long,
    ' it's not a valid address.
    If Len(strAddress) < 7 Then GoTo Fail_Validation

    ' Check for certain generably allowable characters in the leading position.
    ' If found, it's not a valid address.
    strCurrentChar = Left$(strAddress, 1)
    If strCurrentChar = "." Or strCurrentChar = "@" Or strCurrentChar = "_" Or _
        strCurrentChar = "-" Then GoTo Fail_Validation

    ' Check the string for non-allowable characters.
    For lngIndex = 1 To Len(strAddress)
        strCurrentChar = Mid$(strAddress, lngIndex, 1)

        ' Count the number of "@".
        If strCurrentChar = "@" Then lngCountAt = lngCountAt + 1

        ' If there are two consecutive dots, it's not a valid address.
        If strCurrentChar = "." Then
            If lngIndex = lngLastDotPos + 1 Then
                GoTo Fail_Validation
            Else
                lngLastDotPos = lngIndex
            End If
        End If

        Select Case Asc(strCurrentChar)
            ' These characters are not allowable in e-mail addresses.
            Case 1 To 44, 47, 58 To 63, 91 To 94, 96, 123 To 127, 128 To 255
                GoTo Fail_Validation
        End Select
    Next lngIndex

    ' If there isn't one, and only one "@", then it's not a valid address.
    If lngCountAt <> 1 Then GoTo Fail_Validation

    ' If the extension isn't a known one, it's not a valid address.
    Select Case Right$(strAddress, 4)
        Case ".com", ".org", ".net", ".edu", ".mil", ".gov"
            ' Yes, it's valid.
        Case Else
            GoTo Fail_Validation
    End Select

ValidateEMail_Exit:
    Exit Function

Fail_Validation:
    ValidateEMail = False
    GoTo ValidateEMail_Exit
End Function
