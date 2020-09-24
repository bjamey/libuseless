' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Call the Browse For Folder Dialog
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Option Explicit

Private Type BrowseInfo
    hOwner           As Long
    pidlRoot         As Long
    pszDisplayName   As String
    lpszTitle        As String
    ulFlags          As Long
    lpfn             As Long
    lParam           As Long
    iImage           As Long
End Type

Private Declare Function SHSimpleIDListFromPath Lib "Shell32" Alias "#162" (ByVal szPath As String) As Long

Private Declare Function SHGetPathFromIDList Lib "shell32.dll" Alias "SHGetPathFromIDListA" (ByVal pidl As Long, ByVal pszPath As String) As Long
Private Declare Function SHBrowseForFolder Lib "shell32.dll" Alias "SHBrowseForFolderA" (lpBrowseInfo As BrowseInfo) As Long
Private Declare Sub CoTaskMemFree Lib "ole32.dll" (ByVal pv As Long)


' ----------
' Functions
' ----------

Public Function BrowseForFolders(hwnd As Long, Optional ByVal RootDir As String, Optional ByVal TitleCaption As String) As String
    On Error Resume Next

    Const BIF_RETURNONLYFSDIRS As Long = &H1

    Dim bi As BrowseInfo, pidl As Long, Path As String

    With bi
        .hOwner = hwnd
        .pidlRoot = 0&
        .ulFlags = BIF_RETURNONLYFSDIRS
        .lpfn = FARPROC(AddressOf BrowseCallbackProcStr)

        .lParam = 0&
        If Len(TitleCaption) <> 0 Then .lpszTitle = TitleCaption
        If Len(RootDir) <> 0 Then
            RootDir = RootDir & vbNullChar
            .lParam = SHSimpleIDListFromPath(RootDir)
        End If
    End With

    pidl = SHBrowseForFolder(bi)
    Path = Space$(MAX_PATH)
    SHGetPathFromIDList ByVal pidl, ByVal Path
    CoTaskMemFree pidl

    BrowseForFolders = Trim$(Replace$(Path, vbNullChar, vbNullString))
End Function

' ==================================================== '

Public Function BrowseCallbackProcStr( _
        ByVal hwnd As Long, _
        ByVal uMsg As Long, _
        ByVal lParam As Long, _
        ByVal lpData As Long _
    ) As Long

    'On initialization, set the dialog's
    'pre-selected folder from the pointer
    'to the path allocated as bi.lParam,
    'passed back to the callback as lpData param.

    Const WM_USER As Long = &H400
    Const BFFM_SETSELECTIONA As Long = (WM_USER + 102)
'    Const BFFM_SETSELECTIONW As Long = (WM_USER + 103)
    Const BFFM_INITIALIZED As Long = 1

    If uMsg = BFFM_INITIALIZED Then Call SendMessage(hwnd, BFFM_SETSELECTIONA, False, ByVal lpData)
End Function

' ==================================================== '

Public Function FARPROC(pfn As Long) As Long
    'A dummy procedure that receives and returns
    'the value of the AddressOf operator.

    'This workaround is needed as you can't assign
    'AddressOf directly to a member of a user-
    'defined type, but you can assign it to another
    'long and use that (as returned here)
    FARPROC = pfn
End Function
