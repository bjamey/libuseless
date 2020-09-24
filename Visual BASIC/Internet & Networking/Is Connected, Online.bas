' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Is Connected, Online
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------
Public Declare Function InternetGetConnectedState _Lib "wininet.dll"(ByRef lpdwFlags As Long, _
    ByVal dwReserved As Long) As Long

    Public Const INTERNET_CONNECTION_MODEM_BUSY As Long = &H8
    Public Const INTERNET_RAS_INSTALLED As Long = &H10
    Public Const INTERNET_CONNECTION_OFFLINE As Long = &H20
    Public Const INTERNET_CONNECTION_CONFIGURED As Long = &H40

' ---------------
' Function
' ---------------
Public Function IsNetConnectOnline() As Boolean
    IsNetConnectOnline = InternetGetConnectedState(0&, 0&)
End Function
