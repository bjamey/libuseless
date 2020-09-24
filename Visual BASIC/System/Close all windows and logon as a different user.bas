' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Close all windows and logon as a different user
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ---------------
' Declarations
' ---------------

Private Const EWX_LogOff As Long = 0
Private Declare Function ExitWindowsEx Lib "user32" (ByVal dwOptions As Long, ByVal dwReserved As Long) As Long


' ---------------
' Function
' ---------------

' close all programs and log on as a different user
Sub CloseWindows()
    Dim lngResult As Long
    lngResult = ExitWindowsEx(EWX_LogOff, 0&)
End Sub
