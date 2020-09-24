' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get File Version
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Sub MoveMemory Lib "kernel32" Alias "RtlMoveMemory" (dest As Any, ByVal Source As Long, ByVal length As Long)

Private Declare Function VerQueryValue Lib "Version.dll" Alias "VerQueryValueA" (pBlock As Any, ByVal lpSubBlock As String, lplpBuffer As Any, puLen As Long) As Long
Private Declare Function GetFileVersionInfo Lib "Version.dll" Alias "GetFileVersionInfoA" (ByVal lptstrFilename As String, ByVal dwhandle As Long, ByVal dwlen As Long, lpData As Any) As Long
Private Declare Function GetFileVersionInfoSize Lib "Version.dll" Alias "GetFileVersionInfoSizeA" (ByVal lptstrFilename As String, lpdwHandle As Long) As Long

Private Type VS_FIXEDFILEINFO
   dwSignature As Long
   dwStrucVersionl As Integer     '  e.g. = &h0000 = 0
   dwStrucVersionh As Integer     '  e.g. = &h0042 = .42
   dwFileVersionMSl As Integer    '  e.g. = &h0003 = 3
   dwFileVersionMSh As Integer    '  e.g. = &h0075 = .75
   dwFileVersionLSl As Integer    '  e.g. = &h0000 = 0
   dwFileVersionLSh As Integer    '  e.g. = &h0031 = .31
   dwProductVersionMSl As Integer '  e.g. = &h0003 = 3
   dwProductVersionMSh As Integer '  e.g. = &h0010 = .1
   dwProductVersionLSl As Integer '  e.g. = &h0000 = 0
   dwProductVersionLSh As Integer '  e.g. = &h0031 = .31
   dwFileFlagsMask As Long        '  = &h3F for version "0.42"
   dwFileFlags As Long            '  e.g. VFF_DEBUG Or VFF_PRERELEASE
   dwFileOS As Long               '  e.g. VOS_DOS_WINDOWS16
   dwFileType As Long             '  e.g. VFT_DRIVER
   dwFileSubtype As Long          '  e.g. VFT2_DRV_KEYBOARD
   dwFileDateMS As Long           '  e.g. 0
   dwFileDateLS As Long           '  e.g. 0
End Type


' ----------
' Function
' ----------

Public Function GetFileVersion(ByVal FileName As String) As Single
    On Error Resume Next

    Dim lBufferLen As Long, lVerPointer As Long, udtVerBuffer As VS_FIXEDFILEINFO
    Dim rc As Long, lDummy As Long, sBuffer() As Byte
    Dim lVerbufferLen As Long

    Dim StrucVer As String, FileVer As String   ', ProdVer As String

    '*** Get size ****
    lBufferLen = GetFileVersionInfoSize(FileName, lDummy)
    If (lBufferLen < 1) Then Exit Function

    '**** Store info to udtVerBuffer struct ****
    ReDim sBuffer(lBufferLen)
    rc = GetFileVersionInfo(FileName, 0&, lBufferLen, sBuffer(0))
    rc = VerQueryValue(sBuffer(0), "\", lVerPointer, lVerbufferLen)
    MoveMemory udtVerBuffer, lVerPointer, Len(udtVerBuffer)

    '**** Determine File Version number ****
    GetFileVersion = CSng(udtVerBuffer.dwFileVersionMSh) + CSng(udtVerBuffer.dwFileVersionMSl) * 0.1
End Function
