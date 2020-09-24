' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Changes desktop wallpaper instantly without having to reboot
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, ByVal lpvParam As Any, ByVal fuWinIni As Long) As Long

Public Const SPI_SETDESKWALLPAPER = 20

' -----------
' Function
' -----------

Sub ChangeWallPaper(NewPictureFile As String)
    Dim ChangeWP
    ChangeWP = SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, NewPictureFile, 0)
End Sub
