' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Sets the volume label for a drive
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Declare Function SetVolumeLabel Lib "kernel32" Alias "SetVolumeLabelA" (ByVal lpRootPathName As String, ByVal lpVolumeName As String) As Long


' ----------
' Function
' ----------

Public Function SetLabel(RootName As String, NewLabel As String)
       If RootName = "" Then
          Exit Function
       End If

       Call SetVolumeLabel(RootName,NewLabel)
End Function
