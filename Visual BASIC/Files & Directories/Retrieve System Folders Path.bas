' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrieve System Folders Path
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

' These are the api calls needed to get the folder information
Declare Function SHGetSpecialFolderLocation Lib "Shell32" (ByVal hwnd As Long, ByVal nFolder As Long, pidl As Long) As Long
Declare Function SHGetPathFromIDList Lib "Shell32" (pidl As Long, ByVal FolderPath As String) As Long
Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long

'    Desktop = 0
'    StartMenu_Programs = 2
'    My_Documents = 5
'    Favorites_Folder = 6
'    Startup = 7
'    Recent = 8
'    SentTo = 9
'    Start_Menu = 11
'    Windows_Desktop = 16
'    Network_Neighborhood = 19
'    Fonts = 20
'    ShellNew = 21
'    AllUsers_Desktop = 25
'    ApplicationData = 26
'    Printhood = 27
'    TemporaryInternetFiles = 32
'    Cookies = 33
'    History = 34

'----------------
'- Public enums
'----------------
Public Enum STGM
    STGM_DIRECT = &H0&
    STGM_TRANSACTED = &H10000
    STGM_SIMPLE = &H8000000
    STGM_READ = &H0&
    STGM_WRITE = &H1&
    STGM_READWRITE = &H2&
    STGM_SHARE_DENY_NONE = &H40&
    STGM_SHARE_DENY_READ = &H30&
    STGM_SHARE_DENY_WRITE = &H20&
    STGM_SHARE_EXCLUSIVE = &H10&
    STGM_PRIORITY = &H40000
    STGM_DELETEONRELEASE = &H4000000
    STGM_CREATE = &H1000&
    STGM_CONVERT = &H20000
    STGM_FAILIFTHERE = &H0&
    STGM_NOSCRATCH = &H100000
End Enum

Public Enum SHELLFOLDERS            ' Shell Folder Path Constants...
    CSIDL_DESKTOP = &H0&    ' ..\WinNT\profiles\username\Desktop
    CSIDL_PROGRAMS = &H2&    ' ..\WinNT\profiles\username\Start Menu\Programs
    CSIDL_CONTROLS = &H3&    ' No Path
    CSIDL_PRINTERS = &H4&    ' No Path
    CSIDL_PERSONAL = &H5&    ' ..\WinNT\profiles\username\Personal
    CSIDL_FAVORITES = &H6&    ' ..\WinNT\profiles\username\Favorites
    CSIDL_STARTUP = &H7&    ' ..\WinNT\profiles\username\Start Menu\Programs\Startup
    CSIDL_RECENT = &H8&    ' ..\WinNT\profiles\username\Recent
    CSIDL_SENDTO = &H9&    ' ..\WinNT\profiles\username\SendTo
    CSIDL_BITBUCKET = &HA&    ' No Path
    CSIDL_STARTMENU = &HB&    ' ..\WinNT\profiles\username\Start Menu
    CSIDL_DESKTOPDIRECTORY = &H10&    ' ..\WinNT\profiles\username\Desktop
    CSIDL_DRIVES = &H11&    ' No Path
    CSIDL_NETWORK = &H12&    ' No Path
    CSIDL_NETHOOD = &H13&    ' ..\WinNT\profiles\username\NetHood
    CSIDL_FONTS = &H14&    ' ..\WinNT\fonts
    CSIDL_TEMPLATES = &H15&    ' ..\WinNT\ShellNew
    CSIDL_COMMON_STARTMENU = &H16&    ' ..\WinNT\profiles\All Users\Start Menu
    CSIDL_COMMON_PROGRAMS = &H17&    ' ..\WinNT\profiles\All Users\Start Menu\Programs
    CSIDL_COMMON_STARTUP = &H18&    ' ..\WinNT\profiles\All Users\Start Menu\Programs\Startup
    CSIDL_COMMON_DESKTOPDIRECTORY = &H19&    '..\WinNT\profiles\All Users\Desktop
    CSIDL_APPDATA = &H1A&    ' ..\WinNT\profiles\username\Application Data
    CSIDL_PRINTHOOD = &H1B&    ' ..\WinNT\profiles\username\PrintHood
End Enum


' ---------
' Functions
' ---------

Public Function FindSystemFolder(ByVal lngNum As Long) As String
    On Error Resume Next

    Dim lpStartupPath As String * 240, pidl As Long, hResult As Long

    ' Find if a folder does exist with that number
    hResult = SHGetSpecialFolderLocation(0, lngNum, pidl)

    If hResult = 0 Then ' There is a result                                           
        ' Get the actualy directory name
        hResult = SHGetPathFromIDList(ByVal pidl, lpStartupPath)

        If hResult = 1 Then
            ' Strip the string of all miscellaneous and unused characters
            lpStartupPath = left$(Trim$(lpStartupPath), InStr(lpStartupPath, Chr(0)) - 1)
            FindSystemFolder = Trim$(lpStartupPath)
        End If
    End If
End Function
