' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Determine if a control got focus by Tab key or mouse click
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Declare Function GetKeyState% Lib "User" (ByVal nVirtKey%)
Const VK_TAB = 9

' -----------------
' Code
' -----------------

Sub Text1_GotFocus ()
    If GetKeyState(VK_TAB) < 0 Then
       Text1.SelStart = 0
       Text1.SelLength = Len(Text1.Text)
    Else
        Text1.SelLength = 0
    End If
End Sub
