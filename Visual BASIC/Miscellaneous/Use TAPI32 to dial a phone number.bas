' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Use TAPI32 to dial a phone number
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function tapiRequestMakeCall& Lib "TAPI32.DLL" (ByVal DestAddress$, ByVal AppName$, ByVal CalledParty$, ByVal Comment$)

Private Const TAPIERR_NOREQUESTRECIPIENT = -2&
Private Const TAPIERR_REQUESTQUEUEFULL = -3&
Private Const TAPIERR_INVALDESTADDRESS = -4&


' ---------
' Function
' ---------

public Sub DialNumber(strNumber As String, strLocation As String)
    Dim strBuff As String
    Dim lngResult As Long

    lngResult = tapiRequestMakeCall&(strNumber, CStr(Caption), strLocation, "")

    If lngResult <> 0 Then
        strBuff = "Error dialing number : "

        Select Case lngResult
            Case TAPIERR_NOREQUESTRECIPIENT
                strBuff = strBuff & "No Windows Telephony dialing application is running and none could be started."
            Case TAPIERR_REQUESTQUEUEFULL
                strBuff = strBuff & "The queue of pending Windows Telephony dialing requests is full."
            Case TAPIERR_INVALDESTADDRESS
                strBuff = strBuff & "The phone number is not valid."
            Case Else
                strBuff = strBuff & "Unknown error."
        End Select

        MsgBox strBuff
    End If
End Sub
