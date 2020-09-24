' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Form Always on Top
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ---------------
' Usage :
' ---------------
'     AlwaysOnTop(Me, True) ' Use this as the call to this fuction.


' ----------------------------
' Constants & API Declarations
' ----------------------------
Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Public Const HWND_TOPMOST = -1
Public Const HWND_NOTOPMOST = -2
Public Const SWP_NOACTIVATE = &H10
Public Const SWP_SHOWWINDOW = &H40


' ---------------
' Function
' ---------------
Public Sub AlwaysOnTop(FormName As Form, SetOnTop As Boolean)
    If SetOnTop Then
        lFlag = HWND_TOPMOST
    Else
        lFlag = HWND_NOTOPMOST
    End If

    SetWindowPos FormName.hwnd, lFlag, _
    FormName.Left / Screen.TwipsPerPixelX, _
    FormName.Top / Screen.TwipsPerPixelY, _
    FormName.Width / Screen.TwipsPerPixelX, _
    FormName.Height / Screen.TwipsPerPixelY, _
    SWP_NOACTIVATE Or SWP_SHOWWINDOW
End Sub
