' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Plays Wave files, Midi files, AVI Video files..
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Declarations

'   Multimedia Class
'   ~~~~~~~~~~~~~~~~
'
'   Declare As follows:
'
'       Dim MMPlayer As New clsMultimedia
'
'
'   Properties:
'
'       Filename            (String       The media file currently open)
'       Wait                (True/False   If the code should pause until until the file has finished playing)
'       Length              (Integer      The length (in seconds?) of the media file)
'       Position            (Integer      The position of the 'playback head')
'       Status              (String       What's happening to the media file...playing, stopped etc.)
'
'
'
'
'
'   Methods:
'
'       mmOpen(Filename)    (Open a media file specified by "Filename")
'       mmClose()           (Close the currently open media file)
'       mmPlay              (Plays the currently open media file)
'       mmPause()           (Pause the currently playing media file)
'       mmStop              (Stop the currently playing media file)
'       mmSeek(Time)        (Move the playback head to a position specified by "Time")

Option Explicit

Private sAlias As String

Private sFilename As String
Private nLength As Single

Private nPosition As Single
Private sStatus As Single
Private bWait As Boolean

Private Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" (ByVal lpstrCommand As String, ByVal lpstrReturnString As String, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long


' ---------------
' Code
' ---------------

Public Sub mmOpen(ByVal sTheFile As String)
    Dim nReturn As Long
    Dim sType As String

    If sAlias <> "" Then
        mmClose
    End If

    Select Case UCase$(Right$(sTheFile, 3))
        Case "WAV"
            sType = "Waveaudio"
        Case "AVI"
            sType = "AviVideo"
        Case "MID"
            sType = "Sequencer"
        Case "MP3"
            sType = "MPegVideo"
        Case Else
            Exit Sub
    End Select

    Randomize
    sAlias = Right$(sTheFile, 3) & Minute(Now) & Second(Now) & Int(1000 * Rnd + 1)

    If InStr(sTheFile, " ") Then sTheFile = Chr(34) & sTheFile & Chr(34)
    nReturn = mciSendString("Open " & sTheFile & " ALIAS " & sAlias & " TYPE " & sType & " wait", "", 0, 0)

End Sub

Public Sub mmClose()
    Dim nReturn As Long

    If sAlias = "" Then Exit Sub

    nReturn = mciSendString("Close " & sAlias, "", 0, 0)
    sAlias = ""
    sFilename = ""
End Sub

Public Sub mmPause()
    Dim nReturn As Long

    If sAlias = "" Then Exit Sub

    nReturn = mciSendString("Pause " & sAlias, "", 0, 0)
End Sub

Public Sub mmPlay()
    Dim nReturn As Long

    If sAlias = "" Then Exit Sub

    If bWait Then
        nReturn = mciSendString("Play " & sAlias & " wait", "", 0, 0)
    Else
        nReturn = mciSendString("Play " & sAlias, "", 0, 0)
    End If
End Sub

Public Sub mmStop()
    Dim nReturn As Long

    If sAlias = "" Then Exit Sub

    nReturn = mciSendString("Stop " & sAlias, "", 0, 0)
End Sub

Public Sub mmSeek(ByVal nPosition As Single)
    Dim nReturn As Long

    nReturn = mciSendString("seek " & sAlias & " to " & nPosition, "", 0, 0)
End Sub

Property Get FileName() As String
    FileName = sFilename
End Property

Property Let FileName(ByVal sTheFile As String)
    mmOpen sTheFile
End Property

Property Get Wait() As Boolean
    Wait = bWait
End Property

Property Let Wait(bWaitValue As Boolean)
    bWait = bWaitValue
End Property

Property Get Length() As Single
    Dim nReturn As Long, nLength As Integer

    Dim sLength As String * 255

    If sAlias = "" Then
        Length = 0
        Exit Property
    End If

    nReturn = mciSendString("Status " & sAlias & " length", sLength, 255, 0)
    nLength = InStr(sLength, Chr$(0))
    Length = Val(Left$(sLength, nLength - 1))
End Property

Property Let Position(ByVal nPosition As Single)
    mmSeek nPosition
End Property

Property Get Position() As Single
    Dim nReturn As Integer, nLength As Integer

    Dim sPosition As String * 255

    If sAlias = "" Then Exit Property

    nReturn = mciSendString("Status " & sAlias & " position", sPosition, 255, 0)
    nLength = InStr(sPosition, Chr$(0))
    Position = Val(Left$(sPosition, nLength - 1))
End Property

Property Get Status() As String
    Dim nReturn As Integer, nLength As Integer

    Dim sStatus As String * 255

    If sAlias = "" Then Exit Property

    nReturn = mciSendString("Status " & sAlias & " mode", sStatus, 255, 0)

    nLength = InStr(sStatus, Chr$(0))
    Status = Left$(sStatus, nLength - 1)
End Property
