' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Shut down System
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Private Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, lpvParam As Any, ByVal fuWinIni As Long) As Long
Private Declare Function ExitWindowsEx Lib "user32" (ByVal uFlags As Long, ByVal dwReserved As Long) As Long

Private Const EWX_SHUTDOWN = 1

' ---------------
' Function
' ---------------

Private sub Shutdown()
        Dim ret As Integer
        Dim pOld As Boolean

        ret = SystemParametersInfo(97, False, pOld, 0)
End Sub
