' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Disable, Enable Ctrl + Alt + Del, Alt + Tab, And Ctrl + Esc
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, lpvParam As Any, ByVal fuWinIni As Long) As Long

Private Const SPI_SCREENSAVERRUNNING = 97


' ---------------
' Function
' ---------------

Sub Change_TaskView(Enable As Boolean)
    Dim eTask As Integer
    Dim junk As Boolean

    eTask = SystemParametersInfo(SPI_SCREENSAVERRUNNING, Not Enable, junk, 0)
End Sub
