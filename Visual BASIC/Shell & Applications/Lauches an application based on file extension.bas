' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Lauches an application based on file extension
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Private Declare Function GetDesktopWindow Lib "user32" Alias "GetDesktopWindow" () As Long

' ----------
' Function
' ----------

Function StartDoc (DocName As String) as long
    Dim Scr_hDC as long

    Scr_hDC = GetDesktopWindow()

    ' Change "Open" to "Explore" to bring up file explorer
    StartDoc = ShellExecute(Scr_hDC, "Open", DocName, "", "C:\", 1)
End Function
