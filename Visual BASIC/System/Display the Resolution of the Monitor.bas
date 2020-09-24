' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Display the Resolution of the Monitor
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Declarations

Private Declare Function GetSystemMetrics Lib "User32" (ByVal index As Long) As Long
Dim X As Long, Y As Long

' Code

Private Sub Command1_Click()
    x = GetSystemMetrics(0)
    y = GetSystemMetrics(1)

    Msgbox "Resolutions is : " & CStr(x) & " X "  & CStr(y),vbExclamation,"Monitor"
End Sub
