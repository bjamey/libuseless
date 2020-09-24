' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Play an AVI File in Full Screen
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" (ByVal lpstrCommand As String, ByVal lpstrReturnString As Any, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long


' ------
' Code
' ------

Sub Play_AVI(FileName As String)
    Dim lngReturnVal As Long

    lngReturnVal = mciSendString("play " & FileName & " fullscreen ", 0&, 0, 0&)
End Sub
