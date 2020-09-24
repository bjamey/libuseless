' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Hides, Shows the entire Task Bar
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long

Const SWP_HIDEWINDOW = &H80
Const SWP_SHOWWINDOW = &H40


' ----------
' Functions
' ----------

Sub Hide_TaskBar()
    ' Hide The Task Bar

    Dim hwnd1 As Long

    hwnd1 = FindWindow("Shell_traywnd", "")
    Call SetWindowPos(hwnd1, 0, 0, 0, 0, 0, SWP_HIDEWINDOW)
End Sub

' ========================================== '

Sub Show_TaskBar()
    ' Show The Task Bar

    Dim hwnd1 As Long

    hwnd1 = FindWindow("Shell_traywnd", "")
    Call SetWindowPos(hwnd1, 0, 0, 0, 0, 0, SWP_SHOWWINDOW)
End Sub
