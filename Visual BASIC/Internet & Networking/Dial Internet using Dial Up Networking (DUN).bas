' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Dial Internet using Dial Up Networking (DUN)
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Const Internet_Autodial_Force_Unattended As Long = 2

Public Declare Function InternetAutodial Lib "wininet.dll" (ByVal dwFlags As Long, ByVal dwReserved As Long) As Long
Public Declare Function InternetAutodialHangup Lib "wininet.dll" (ByVal dwReserved As Long) As Long


' --------
' Code
' --------

Sub Dial()
    Dim lResult As Long
    lResult = InternetAutodial(Internet_Autodial_Force_Unattended, 0&)
End Sub
