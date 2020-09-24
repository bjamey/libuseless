' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Hide, Unhide Your Desktop Icons
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Option Explicit

Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long
Private Declare Function ShowWindow Lib "user32" (ByVal hWnd As Long, ByVal nCmdShow As Long) As Long


' ----------------------------
' Code
' ----------------------------

Sub Change_DesktopIcons(isVisible As Boolean)
    Dim hWnd As Long

    hWnd = FindWindowEx(0&, 0&, "Progman", vbNullString)

    If isVisible Then
       ' Show Desktop
       ShowWindow hWnd, 5
    Else
        ' Hide Desktop
        ShowWindow hWnd, 0
    End If
End Sub
