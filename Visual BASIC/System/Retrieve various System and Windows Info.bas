' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrieve various System and Windows Info
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

'Windows System Information Constants
Private Const SQL_SUCCESS As Long = 0
Private Const SQL_FETCH_NEXT = 1
Private Const SQL_FETCH_FIRST_SYSTEM = 32

Private Const SECS_PER_DAY As Long = 86000
Private Const MINS_PER_DAY As Long = 1400

'Enumerated Types
Public Enum ControlPanelTypes
    cplSystem = 1
    cplInternet = 2
    cplModem = 3
    cplSoftware = 4
    cplHardware = 5
    cplSounds = 6
    cplNetwork = 7
    cplMouse = 8
    cplKeyboard = 9
    cplDateTime = 10
    cplRegional = 11
    cplPassword = 12
    cplDisplay = 13
End Enum

Public Enum DIR_TYPE
    dirWINDOWS
    dirSYSTEM
    dirTEMP
End Enum

Public Enum DRIVE_TYPE
    DRIVE_DOESNT_EXIST = 1
    DRIVE_REMOVABLE = 2
    DRIVE_FIXED = 3
    DRIVE_REMOTE = 4
    DRIVE_CDROM = 5
    DRIVE_RAMDISK = 6
End Enum

Public Enum enStockIcons
    IDI_APPLICATION = 32512&
    IDI_ASTERISK = 32516&
    IDI_EXCLAMATION = 32515&
    IDI_HAND = 32513&   'This is the STOP icon
    IDI_QUESTION = 32514&
End Enum

Public Enum OS_VERSION
    OS_WINDOWS_UNKNOWN
    OS_WINDOWS_3X
    OS_WINDOWS_95
    OS_WINDOWS_98
    OS_WINDOWS_NT3X
    OS_WINDOWS_NT40
    OS_WINDOWS_2000
End Enum

Private Type OSVERSIONINFOEX
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion As String * 128
End Type

Private Type MEMORYSTATUS
    dwLength As Long
    dwMemoryLoad As Long
    dwTotalPhys As Long
    dwAvailPhys As Long
    dwTotalPageFile As Long
    dwAvailPageFile As Long
    dwTotalVirtual As Long
    dwAvailVirtual As Long
End Type

Public Enum ShutdownType
    Logoff = 0
    ByeBye = 1
    Reboot = 2
End Enum

Private Const VER_PLATFORM_WIN32s = 0
Private Const VER_PLATFORM_WIN32_WINDOWS = 1
Private Const VER_PLATFORM_WIN32_NT = 2

Private Const BITSPIXEL = 12
Private Const PLANES = 14

' API Declarations for the Locale Methods
Private Declare Sub GlobalMemoryStatus Lib "kernel32" (lpBuffer As MEMORYSTATUS)
'API Functions
Private Declare Function DrawIconApi Lib "user32" Alias "DrawIcon" (ByVal HDC As Long, ByVal x As Long, ByVal Y As Long, ByVal hIcon As Long) As Long
Private Declare Function ExitWindowsEx Lib "user32" (ByVal dwOptions As Long, ByVal dwReserved As Long) As Long
Private Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal HDC As Long, ByVal nIndex As Long) As Long
Private Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceA" (ByVal lpRootPathName As String, lpSectorsPerCluster As Long, lpBytesPerSector As Long, lpNumberOfFreeClusters As Long, lpTotalNumberOfClusters As Long) As Long
Private Declare Function GetDriveType Lib "kernel32" Alias "GetDriveTypeA" (ByVal nDrive As String) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Private Declare Function GetTickCount Lib "kernel32.dll" () As Long
Private Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFOEX) As Long
Private Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long
Private Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Private Declare Function InternetGetConnectedState Lib "wininet.dll" (ByRef lpSFlags As Long, ByVal dwReserved As Long) As Long
Private Declare Function LoadIconApi Lib "user32" Alias "LoadIconA" (ByVal hInstance As Long, ByVal lpIconName As Long) As Long
Private Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long
Private Declare Function ShellAbout Lib "shell32.dll" Alias "ShellAboutA" (ByVal hWnd As Long, ByVal szApp As String, ByVal szOtherStuff As String, ByVal hIcon As Long) As Long
Private Declare Function SQLAllocEnv Lib "odbc32.dll" (phenv As Long) As Integer
Private Declare Function SQLDataSources Lib "odbc32.dll" (ByVal hEnv As Long, ByVal fDirection As Integer, ByVal szDSN$, ByVal cbDSNMax%, pcbDSN As Integer, ByVal szDescription As String, ByVal cbDescriptionMax As Integer, pcbDescription As Integer) As Integer
Private Declare Function SQLFreeEnv Lib "odbc32.dll" (ByVal hEnv As Long) As Integer
Private Declare Function waveOutGetNumDevs Lib "winmm.dll" () As Long

Private pUdtOSVersion As OSVERSIONINFOEX
Private pUdtMemStatus As MEMORYSTATUS

Private plMajorVersion  As Long
Private plMinorVersion As Long
Private plPlatformID As Long

Private psComputerName As String
Private plLastDllError As Long

'-----------------
'Public Properties
'-----------------
Public Property Get Name() As String
    Dim sBuffer As String
    Dim lAns As Long

    plLastDllError = 0
    sBuffer = Space$(255)
    lAns = GetComputerName(sBuffer, 255)
    If lAns <> 0 Then
        'read from beginning of string to null-terminator
        Name = Left$(sBuffer, InStr(sBuffer, Chr(0)) - 1)
    Else
        plLastDllError = Err.LastDllError
    End If
End Property

Public Property Get CurrentUser() As String
    Dim l As Long
    Dim sUser As String

    plLastDllError = 0
    sUser = Space(255)
    l = GetUserName(sUser, 255)
    'strip null terminator
    If l <> 0 Then
        CurrentUser = Left(sUser, InStr(sUser, Chr(0)) - 1)
    Else
        plLastDllError = Err.LastDllError
    End If
End Property

Public Property Get MaxScreenColors() As Double
    'Returns the maximum number of colors supported
    'by the system - e.g.,  256, 16,777,216
    Dim lngBits As Long
    Dim lngPlanes As Long
    Dim lwndHandle As Long
    Dim dblAns As Double
    plLastDllError = 0
    lwndHandle = Form1.HDC
    'bits per pixel
    lngBits = GetDeviceCaps(lwndHandle, BITSPIXEL)
    'number of color planes
    lngPlanes = GetDeviceCaps(lwndHandle, PLANES)
    'maximum colors available
    MaxScreenColors = (2 ^ (lngBits * lngPlanes))
    plLastDllError = Err.LastDllError
End Property

Public Property Get OSVersion() As OS_VERSION
    On Error GoTo ErrorHandler

    plLastDllError = 0
    Select Case plMajorVersion
        Case 5: OSVersion = OS_WINDOWS_2000 'UNTESTED
        Case 4
            If plPlatformID = VER_PLATFORM_WIN32_NT Then
                OSVersion = OS_WINDOWS_NT40
            Else
                OSVersion = IIf(plMinorVersion = 0, OS_WINDOWS_95, OS_WINDOWS_98)
            End If
        Case 3
            If plPlatformID = VER_PLATFORM_WIN32s Then
                OSVersion = OS_WINDOWS_3X
            ElseIf plPlatformID = VER_PLATFORM_WIN32_NT Then
                OSVersion = OS_WINDOWS_NT40
            End If
        Case Else:  OSVersion = OS_WINDOWS_UNKNOWN
    End Select
Exit Property
ErrorHandler:
    OSVersion = OS_WINDOWS_UNKNOWN
    plLastDllError = Err.LastDllError
End Property

Public Property Get ScreenPixelWidth() As Integer
    plLastDllError = 0
    ScreenPixelWidth = Screen.Width \ Screen.TwipsPerPixelX
End Property

Public Property Get ScreenPixelHeight() As Integer
    plLastDllError = 0
    ScreenPixelHeight = Screen.Height \ Screen.TwipsPerPixelY
End Property

Public Property Get ScreenResolution() As String
    plLastDllError = 0
    ScreenResolution = ScreenPixelWidth & "x" & ScreenPixelHeight
End Property

Public Property Get SystemErrorCode() As Long
    SystemErrorCode = plLastDllError
End Property

Public Property Get SoundCard() As Boolean
     SoundCard = waveOutGetNumDevs > 0
End Property
'----------------
'Public Functions
'----------------
Public Function AboutBox(Optional hWndA As Long = -1, Optional Copyright As String, Optional ProductInfo As String, Optional Icon As Long = 0)
    If Len(Copyright) = 0 Then Copyright = Common.Version() & "#" & App.ProductName
    If Len(ProductInfo) = 0 Then
        If Len(App.LegalTrademarks) > 0 And Len(App.CompanyName) > 0 Then
            ProductInfo = App.LegalTrademarks
            ProductInfo = ProductInfo & " are legal trademarks of "
            ProductInfo = ProductInfo & App.CompanyName
        Else
            ProductInfo = ProjectName
            ProductInfo = ProductInfo & " is a legal trademark of "
            ProductInfo = ProductInfo & IIf(Len(App.CompanyName) > 0, App.CompanyName, "FailSafe Systems")
        End If
    End If
    Call ShellAbout(hWndA, Copyright, ProductInfo, Icon)
End Function

Public Function APIFunctionPresent(ByVal FunctionName As String, ByVal DLLName As String) As Boolean
    'USAGE: Dim bAvail as boolean
    '       bAvail = APIFunctionPresent("GetDiskFreeSpaceExA", "kernel32")
    Dim lHandle As Long
    Dim lAddr  As Long
    lHandle = LoadLibrary(DLLName)
    If lHandle <> 0 Then
        lAddr = GetProcAddress(lHandle, FunctionName)
        FreeLibrary lHandle
    End If
    APIFunctionPresent = (lAddr <> 0)
End Function

Public Sub CascadeWindows()
' TODO:
'    Dim objShell As New Shell32.Shell
'    objShell.CascadeWindows
'    Set objShell = Nothing
End Sub

Public Function ControlPanel(Setting As ControlPanelTypes) As Long
    Dim lPanel As String
    Select Case Setting
        Case cplSoftware:   lPanel = "appwiz.cpl,,1"
        Case cplHardware:   lPanel = "sysdm.cpl @1"
        Case cplInternet:   lPanel = "inetcpl.cpl,,0"
        Case cplKeyboard:   lPanel = "main.cpl @1"
        Case cplModem:      lPanel = "modem.cpl"
        Case cplMouse:      lPanel = "main.cpl @0"
        Case cplNetwork:    lPanel = "netcpl.cpl"
        Case cplSounds:     lPanel = "mmsys.cpl @1"
        Case cplSystem:     lPanel = "sysdm.cpl,,0"
        Case cplDisplay:    lPanel = "desk.cpl,,0"
        Case cplPassword:   lPanel = "password.cpl"
        Case cplRegional:   lPanel = "intl.cpl,,0"
        Case cplDateTime:   lPanel = "timedate.cpl"
    End Select
    If Len(lPanel) > 0 Then ControlPanel = Shell("rundll32.exe shell32.dll,Control_RunDLL " & lPanel, 5)
    plLastDllError = Err.LastDllError
End Function

Public Function Directory(WhichDir As DIR_TYPE) As String
    Dim Temp As String
    Dim Ret As Long
    Const MAX_LENGTH = 255

    Temp = String$(MAX_LENGTH, 0)
    Select Case WhichDir
        Case dirWINDOWS:    Ret = GetWindowsDirectory(Temp, MAX_LENGTH)
        Case dirSYSTEM:     Ret = GetSystemDirectory(Temp, MAX_LENGTH)
        Case dirTEMP:       Ret = GetTempPath(Len(Temp), Temp)
        Case Else:          Ret = 0: Temp = ""
    End Select
    Directory = PathCheck(Left$(Temp, Ret))
End Function

Public Function DriveMBFree(Optional Drive As String = "C:\") As Double
    'some time in the future disk may be to large to calculate
    'like this so resume next on any errors
    On Error Resume Next

    Dim lAns As Long
    Dim lSectorsPerCluster As Long
    Dim lBytesPerSector As Long

    Dim lFreeClusters As Long
    Dim lTotalClusters As Long
    Dim lBytesPerCluster As Long
    Dim lFreeBytes As Double

    'fix bad parameter values
    If Len(Drive) = 1 Then Drive = Drive & ":\"
    If Len(Drive) = 2 And Right$(Drive, 1) = ":" Then Drive = Drive & "\"

    lAns = GetDiskFreeSpace(Drive, lSectorsPerCluster, lBytesPerSector, lFreeClusters, lTotalClusters)
    lBytesPerCluster = lSectorsPerCluster * lBytesPerSector

    DriveMBFree = ((lBytesPerCluster / 1024) / 1024) * lFreeClusters
    DriveMBFree = Format(DriveMBFree, "###,###,##0.00")
End Function

Public Function DriveMBSize(Optional Drive As String = "C:\") As Double
    'some time in the future disk may be to large to calculate
    'like this so resume next on any errors
    On Error Resume Next

    Dim lAns As Long
    Dim lSectorsPerCluster As Long
    Dim lBytesPerSector As Long

    Dim lFreeClusters As Long
    Dim lTotalClusters As Long
    Dim lBytesPerCluster As Long
    Dim lTotalBytes As Double

    'fix bad parameter values
    If Len(Drive) = 1 Then Drive = Drive & ":\"
    If Len(Drive) = 2 And Right$(Drive, 1) = ":" Then Drive = Drive & "\"

    lAns = GetDiskFreeSpace(Drive, lSectorsPerCluster, lBytesPerSector, lFreeClusters, lTotalClusters)
    lBytesPerCluster = lSectorsPerCluster * lBytesPerSector

    DriveMBSize = ((lBytesPerCluster / 1024) / 1024) * lTotalClusters
    DriveMBSize = Format(DriveMBSize, "###,###,##0.00")
End Function

Public Function DriveName(Optional Drive As String = "C:\")
    Dim sBuffer As String

    plLastDllError = 0
    sBuffer = Space$(255)
    'fix bad parameter values
    If Len(Drive) = 1 Then Drive = Drive & ":\"
    If Len(Drive) = 2 And Right$(Drive, 1) = ":" Then Drive = Drive & "\"
    If GetVolumeInformation(Drive, sBuffer, Len(sBuffer), 0, 0, 0, Space$(255), 255) = 0 Then
        plLastDllError = Err.LastDllError
    Else
        DriveName = Left$(sBuffer, InStr(sBuffer, Chr$(0)) - 1)
    End If
End Function

Public Function DriveType(Drive As String) As DRIVE_TYPE
    'fix bad parameter values
    DriveType = DRIVE_DOESNT_EXIST
    plLastDllError = 0
    Drive = IIf(Len(Drive) = 1, Drive & ":", Drive)
    If Len(Drive) = 1 Then Drive = Drive & ":\"
    If Len(Drive) = 2 And Right$(Drive, 1) = ":" Then Drive = Drive & "\"
    Drive = PathCheck(Drive)
    DriveType = GetDriveType(Drive)
    plLastDllError = Err.LastDllError
End Function

Public Sub DSNs(DSNArray() As String)
    'POPULATES DSNARRAY WITH ALL DSNs installed on the system,
    'in the form of "DSN | DRIVER"
    'USAGE:
    'Dim asDSNArray() As String
    'Dim iCtr As Integer
    'SystemDSNs asDSNArray
    'For iCtr = 0 To UBound(asDSNArray)
    '     Debug.Print asDSNArray(iCtr)
    'Next
    Dim iRet As Integer
    Dim sDSN As String
    Dim sDriver As String
    Dim iDSNLen As Integer
    Dim iDriverLen As Integer
    ReDim DSNArray(0) As String
    Dim lEnvHandle As Long

    iRet = SQLAllocEnv(lEnvHandle)
    sDSN = Space(1024)
    sDriver = Space(1024)
    iRet = SQLDataSources(lEnvHandle, SQL_FETCH_FIRST_SYSTEM, sDSN, 1024, iDSNLen, sDriver, 1024, iDriverLen)

    If iRet = SQL_SUCCESS Then
        sDSN = Mid(sDSN, 1, iDSNLen)
        sDriver = Mid(sDriver, 1, iDriverLen)
        DSNArray(0) = sDSN & " | " & sDriver
        Do Until iRet <> SQL_SUCCESS
            sDSN = Space(1024)
            sDriver = Space(1024)
            iRet = SQLDataSources(lEnvHandle, SQL_FETCH_NEXT, sDSN, 1024, iDSNLen, sDriver, 1024, iDriverLen)
            If Trim(sDSN) <> "" Then
                sDSN = Mid(sDSN, 1, iDSNLen)
                sDriver = Mid(sDriver, 1, iDriverLen)
                ReDim Preserve DSNArray(UBound(DSNArray) + 1)
                DSNArray(UBound(DSNArray)) = sDSN & " | " & sDriver
            End If
       Loop
    End If
    iRet = SQLFreeEnv(lEnvHandle)
End Sub

Public Function IsConnectedToInternet(Optional ConnectMode As Integer) As Boolean
    Dim flags As Long
    IsConnectedToInternet = InternetGetConnectedState(flags, 0) ' this ASPI function does it all
    ConnectMode = flags                                         ' return the flag through the optional argument
End Function

Public Function MemoryAvailable() As Double
    'Return Value in Megabytes
     MemoryAvailable = MemoryAvailablePhysical + MemoryPageFile
End Function

Public Function MemoryAvailablePhysical() As Double
    'Return Value in Megabytes
    Dim dblAns As Double
    plLastDllError = 0
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwAvailPhys
    MemoryAvailablePhysical = BytesToMegabytes(dblAns)
    plLastDllError = Err.LastDllError
End Function

Public Function MemoryInTotal() As Double
    'Return Value in Megabytes
    MemoryInTotal = MemoryPageFileSize + MemoryTotalPhysical
End Function

Public Function MemoryPageFile() As Double
    'Return Value in Megabytes
    Dim dblAns As Double

    plLastDllError = 0
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwAvailPageFile
    MemoryPageFile = BytesToMegabytes(dblAns)
    plLastDllError = Err.LastDllError
End Function

Public Function MemoryPageFileSize() As Double
    'Return Value in Megabytes
    Dim dblAns As Double

    plLastDllError = 0
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwTotalPageFile
    MemoryPageFileSize = BytesToMegabytes(dblAns)
    plLastDllError = Err.LastDllError
End Function

Public Function MemoryPercentFree() As Double
    MemoryPercentFree = Format(MemoryAvailable / MemoryInTotal * 100, "0#")
End Function

Public Function MemoryTotalPhysical() As Double
    'Return Value in Megabytes
    Dim dblAns As Double
    plLastDllError = 0
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwTotalPhys
    MemoryTotalPhysical = BytesToMegabytes(dblAns)
    plLastDllError = Err.LastDllError
End Function

Public Function Running(Optional InSeconds As Boolean = False) As Double
    Running = SECS_PER_DAY * (GetTickCount / 1000 / 60 / 60 / 24)
    Running = IIf(InSeconds, Round(Running, 2), Round(Running / 3600, 2))
End Function

Public Function ShutDown(ExitType As ShutdownType) As Long
    ShutDown = ExitWindowsEx(ExitType, 0&)
End Function

Public Function Started() As Date
    Dim dTicks     As Double
    'Store the number of days the systems has been running
    dTicks = GetTickCount / 1000 / 60 / 60 / 24
    Started = Now() - dTicks
End Function

'-----------------
'Private Functions
'-----------------
Private Function BytesToMegabytes(bytes As Double) As Double
  Dim dblAns As Double
  dblAns = (bytes / 1024) / 1024
  BytesToMegabytes = Format(dblAns, "###,###,##0.00")
End Function

Private Function FreeBytesOnDisk(Drive As String) As Long
    On Error Resume Next
    plLastDllError = 0

    Dim lAns As Long
    Dim lSectorsPerCluster As Long
    Dim lBytesPerSector As Long

    Dim lFreeClusters As Long
    Dim lTotalClusters As Long
    Dim lBytesPerCluster As Long
    Dim lFreeBytes As Double


    lAns = GetDiskFreeSpace(Drive, lSectorsPerCluster, lBytesPerSector, lFreeClusters, lTotalClusters)
    lBytesPerCluster = lSectorsPerCluster * lBytesPerSector
    lFreeBytes = lBytesPerCluster * lFreeClusters
    FreeBytesOnDisk = lFreeBytes
    plLastDllError = Err.LastDllError
End Function

Private Function PathCheck(ByVal PathName As String, Optional AltDelimiter As String = "") As String
    If Len(PathName) = 0 Then Exit Function
    Dim Delimiter As String
    Delimiter = IIf(InStr(PathName, "/"), "/", "\")
    PathCheck = IIf(Right$(PathName, 1) = Delimiter, PathName, PathName & Delimiter)
    PathCheck = IIf(Len(AltDelimiter) = 0, PathCheck, Replace(PathCheck, Delimiter, AltDelimiter))
End Function

Private Function TotalBytesOnDisk(Drive As String) As Double
    On Error Resume Next
    plLastDllError = 0
    Dim lAns As Long
    Dim lSectorsPerCluster As Long
    Dim lBytesPerSector As Long

    Dim lFreeClusters As Long
    Dim lTotalClusters As Long
    Dim lBytesPerCluster As Long
    Dim lTotalBytes As Double

    lAns = GetDiskFreeSpace(Drive, lSectorsPerCluster, lBytesPerSector, lFreeClusters, lTotalClusters)
    lBytesPerCluster = lSectorsPerCluster * lBytesPerSector
    'dblAns = (Bytes / 1024) / 1024
    TotalBytesOnDisk = lBytesPerCluster * lTotalClusters
    If TotalBytesOnDisk = 0 Then
        TotalBytesOnDisk = ((lBytesPerCluster / 1024) / 1024) * lTotalClusters
    End If
    plLastDllError = Err.LastDllError
End Function

Public Function LoadSystemIcon(ByVal StockIcon As enStockIcons) As Long
    On Error Resume Next
    LoadSystemIcon = LoadIconApi(0, StockIcon)
End Function


Public Sub DrawIcon(ByVal HDC As Long, ByVal xPos As Long, ByVal yPos As Long, ByVal Icon As Long)
    Dim lRet As Long
    lRet = DrawIconApi(HDC, xPos, yPos, Icon)
    If (Err.LastDllError > 0) Or (lRet = 0) Then Debug.Print "DrawIcon failed"
End Sub
'use:

'---------------------
' Class Initialization
'---------------------
Private Sub Class_Initialize()
    pUdtOSVersion.dwOSVersionInfoSize = Len(pUdtOSVersion)
    GetVersionEx pUdtOSVersion
    plMajorVersion = pUdtOSVersion.dwMajorVersion
    plMinorVersion = pUdtOSVersion.dwMinorVersion
    plPlatformID = pUdtOSVersion.dwPlatformId
End Sub

Private Sub Class_Terminate()
    '
End Sub
