' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Play Wav Sound Files Using Windows API
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Declare Function sndPlaySound Lib "winmm.dll" Alias "sndPlaySoundA" (ByVal lpszSoundName As String, ByVal uFlags As Long) As Long

Public Const SND_ALIAS = &H10000     '  name is a WIN.INI [sounds] entry
Public Const SND_ASYNC = &H1         '  play asynchronously
Public Const SND_LOOP = &H8         '  loop the sound until next sndPlaySound
Public Const SND_NOWAIT = &H2000      '  don't wait if the driver is busy
Public Const SND_SYNC = &H0         '  play synchronously (default)


' ---------------
' Function
' ---------------

Public Sub PlaySound(FileName As String)
    Call sndPlaySound(FileName, 1)
End Sub
