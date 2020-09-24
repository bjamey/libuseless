' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Reboot the computer
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Const EWX_REBOOT As Long = 2
Private Declare Function ExitWindowsEx Lib "user32" (ByVal dwOptions As Long, ByVal dwReserved As Long) As Long


' ----------------------------
' Function
' ----------------------------

Sub Reboot_Computer()
    Dim lngResult As Long
    lngResult = ExitWindowsEx(EWX_REBOOT, 0&)
End Sub
