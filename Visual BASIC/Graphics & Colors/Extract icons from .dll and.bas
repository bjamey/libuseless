' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Extract icons from .dll and
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Option Explicit

Global lIcon&
Global sSourcePgm$
Global sDestFile$

Declare Function ExtractIcon Lib "shell32.dll" Alias "ExtractIconA" (ByVal hInst As Long, ByVal lpszExeFileName As String, ByVal nIconIndex As Long) As Long
Declare Function DrawIcon Lib "user32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal hIcon As Long) As Long
Declare Function DestroyIcon Lib "user32" (ByVal hIcon As Long) As Long


' -------
' Code
' -------


Private Sub Extract_Icon(FileName As String)
  On Error Resume Next

  Dim i As Long
  Dim lIcon As Long

  Do
    lIcon = ExtractIcon(App.hInstance, FileName, i)
    If lIcon = 0 Then Exit Do
    i = i + 1
    DestroyIcon lIcon
  Loop

  If i = 0 Then
    MsgBox "No Icons in this file!"
  End If

  ' Optional: the following code will draw the extracted icon :
  ' DestroyIcon lIcon
  ' Picture1.Cls
  ' lIcon = ExtractIcon(App.hInstance, FileName, i)      ' i = icon index
  ' Picture1.AutoSize = True
  ' Picture1.AutoRedraw = True
  ' DrawIcon Picture1.hdc, 0, 0, lIcon
  ' Picture1.Refresh
End Sub
