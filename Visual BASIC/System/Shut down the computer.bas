' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Shut down the computer
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Const EWX_SHUTDOWN As Long = 1
Private Declare Function ExitWindowsEx Lib "user32" (ByVal dwOptions As Long, ByVal dwReserved As Long) As Long


' ---------
' Function
' ---------

Sub Shutdown_Computer()
    Dim lngResult As Long
    lngResult = ExitWindowsEx(EWX_SHUTDOWN, 0&)
End Sub
