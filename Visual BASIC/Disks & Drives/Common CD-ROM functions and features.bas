' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Common CD-ROM functions and features
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

'Declare for CD-ROM DriveLetter / Volume Label
Private Declare Function GetLogicalDriveStrings _
  Lib "kernel32" Alias "GetLogicalDriveStringsA" _
  (ByVal nBufferLength As Long, _
  ByVal lpBuffer As String) As Long

Private Declare Function GetDriveType _
  Lib "kernel32" Alias "GetDriveTypeA" _
  (ByVal nDrive As String) As Long

Private Declare Function GetVolumeInformation _
  Lib "kernel32" Alias "GetVolumeInformationA" _
  (ByVal lpRootPathName As String, _
  ByVal lpVolumeNameBuffer As String, _
  ByVal nVolumeNameSize As Long, _
  lpVolumeSerialNumber As Long, _
  lpMaximumComponentLength As Long, _
  lpFileSystemFlags As Long, _
  ByVal lpFileSystemNameBuffer As String, _
  ByVal nFileSystemNameSize As Long) As Long

'Const for CD-ROM DriveLetter / Volume Label
Private Const DRIVE_CDROM = 5

'Property holders for CD-ROM DriveLetter / Volume Label
Private sCDROMDrive As String
Private sCDROMVolume As String
Private bCDROMExists As Boolean


'Declare for Eject/Close Feature
Private Declare Function mciSendString Lib "winmm.dll" _
  Alias "mciSendStringA" _
  (ByVal lpstrCommand As String, _
  ByVal lpstrReturnString As String, _
  ByVal uReturnLength As Long, _
  ByVal hwndCallback As Long) As Long

'Const for Eject/Close Feature
Private Const MCI_CDADUIO_DOOR_OPEN = "CDAudio Door Open"
Private Const MCI_CDADUIO_DOOR_CLOSE = "CDAudio Door Close"


' ------
' Code
' ------

Public Sub EjectCD()
   Call mciSendString("Set " & MCI_CDADUIO_DOOR_OPEN & " Wait", 0&, 0&, 0&)
End Sub

Public Sub CloseCD()
   Call mciSendString("Set " & MCI_CDADUIO_DOOR_CLOSE & " Wait", 0&, 0&, 0&)
End Sub

Public Property Get CDDriveLetter() As String
  GetCDROMInformation
  CDDriveLetter = sCDROMDrive
End Property

Public Property Get CDVolumeLabel() As String
  GetCDROMInformation
  CDVolumeLabel = sCDROMVolume
End Property

Public Property Get CDExists() As Boolean
  GetCDROMInformation
  CDExists = bCDROMExists
End Property

Private Sub GetCDROMInformation()
  'get the available drives, determine their type,
  'and if CD, get the CD volume label
  Dim r As Long
  Dim DriveType As Long
  Dim allDrives As String
  Dim JustOneDrive As String
  Dim CDLabel As String
  Dim pos As Integer
  Dim CDfound As Boolean

  'pad the string with spaces
  allDrives = Space$(64)
  'call the API to get the string containing all drives
  r = GetLogicalDriveStrings(Len(allDrives), allDrives)

  'trim off any trailing spaces. 'AllDrives'
  'now contains all the drive letters.
  allDrives = Left$(allDrives, r)
  'begin a loop
  Do
    'first check that there is a chr$(0) in the string
     pos = InStr(allDrives, Chr$(0))
     'if there's one, then...
     If pos Then
       'extract the drive up to the chr$(0)
        JustOneDrive = Left$(allDrives, pos - 1)
       'and remove that from the Alldrives string,
       'so it won't be checked again
        allDrives = Mid$(allDrives, pos + 1)
       'with the one drive, call the API to
       'determine the drive type
        DriveType = GetDriveType(JustOneDrive)
       'check if its what we want
       If DriveType = DRIVE_CDROM Then
          'got it (or at least the first one,
          'anyway, if more than one), so set
          'the found flag... this part can be modified
          'to continue searching remaining drives for
          'those systems that might have more than
          'one CD installed.
          CDfound = True
          DoEvents
          CDLabel = GetVolumeLabel(JustOneDrive)
          'we're done for now, so get out
          Exit Do
       End If
     End If
  Loop Until allDrives = "" Or DriveType = DRIVE_CDROM

  'display the appropriate message
  If CDfound Then
    sCDROMDrive = UCase$(JustOneDrive)
    sCDROMVolume = CDLabel
    bCDROMExists = True
  Else
    sCDROMDrive = ""
    sCDROMVolume = ""
    bCDROMExists = False
  End If
End Sub

Private Function GetVolumeLabel(CDPath As String) As String
  'create working variables  'to keep it simple, use dummy variables for info
  'we're not interested in right now
  Dim r As Long
  Dim DrvVolumeName As String
  Dim pos As Integer
  Dim UnusedVal1 As Long
  Dim UnusedVal2 As Long
  Dim UnusedVal3 As Long
  Dim UnusedStr As String

  DrvVolumeName = Space$(14)
  UnusedStr = Space$(32)

  'do what it says
  r = GetVolumeInformation(CDPath, _
    DrvVolumeName, _
    Len(DrvVolumeName), _
    UnusedVal1, UnusedVal2, _
    UnusedVal3, _
    UnusedStr, Len(UnusedStr))

  'error check
  If r = 0 Then Exit Function

  'the volume label
  pos = InStr(DrvVolumeName, Chr$(0))
  If pos Then DrvVolumeName = Left$(DrvVolumeName, pos - 1)
  If Len(Trim$(DrvVolumeName$)) = 0 Then DrvVolumeName$ = "(no label)"
  GetVolumeLabel = DrvVolumeName$
End Function


Private Sub Class_Initialize()
  'Get the CD-ROM info and initilize the Property valiables
  GetCDROMInformation
End Sub
