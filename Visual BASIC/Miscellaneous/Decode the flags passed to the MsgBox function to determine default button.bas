' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Decode the flags passed to the MsgBox function to determine what the
'         default button is
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetDefMsgBoxButton
' Decode the flags passed to the MsgBox function to
' determine what the default button is.  Use this
' for silent installs.
'
' IN: [intFlags] - Flags passed to MsgBox
'
' Returns: VB defined number for button
'               vbOK        1   OK button pressed.
'               vbCancel    2   Cancel button pressed.
'               vbAbort     3   Abort button pressed.
'               vbRetry     4   Retry button pressed.
'               vbIgnore    5   Ignore button pressed.
'               vbYes       6   Yes button pressed.
'               vbNo        7   No button pressed.
'-----------------------------------------------------------
'
Function GetDefMsgBoxButton(intFlags) As Integer
    '
    ' First determine the ordinal of the default
    ' button on the message box.
    '
    Dim intButtonNum As Integer
    Dim intDefButton As Integer

    If (intFlags And vbDefaultButton2) = vbDefaultButton2 Then
        intButtonNum = 2
    ElseIf (intFlags And vbDefaultButton3) = vbDefaultButton3 Then
        intButtonNum = 3
    Else
        intButtonNum = 1
    End If
    '
    ' Now determine the type of message box we are dealing
    ' with and return the default button.
    '
    If (intFlags And vbRetryCancel) = vbRetryCancel Then
        intDefButton = IIf(intButtonNum = 1, vbRetry, vbCancel)
    ElseIf (intFlags And vbYesNoCancel) = vbYesNoCancel Then
        Select Case intButtonNum
            Case 1
                intDefButton = vbYes
            Case 2
                intDefButton = vbNo
            Case 3
                intDefButton = vbCancel
            'End Case
        End Select
    ElseIf (intFlags And vbOKCancel) = vbOKCancel Then
        intDefButton = IIf(intButtonNum = 1, vbOK, vbCancel)
    ElseIf (intFlags And vbAbortRetryIgnore) = vbAbortRetryIgnore Then
        Select Case intButtonNum
            Case 1
                intDefButton = vbAbort
            Case 2
                intDefButton = vbRetry
            Case 3
                intDefButton = vbIgnore
            'End Case
        End Select
    ElseIf (intFlags And vbYesNo) = vbYesNo Then
        intDefButton = IIf(intButtonNum = 1, vbYes, vbNo)
    Else
        intDefButton = vbOK
    End If

    GetDefMsgBoxButton = intDefButton

End Function
