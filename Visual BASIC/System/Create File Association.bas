' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Create File Association
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ---------------
' How to use :
'
' Call CreateAssociation() to create file association
' ---------------


Option Explicit

'// Windows Registry Messages
Private Const REG_SZ As Long = 1
Private Const REG_DWORD As Long = 4
Private Const HKEY_CLASSES_ROOT = &H80000000
Private Const HKEY_CURRENT_USER = &H80000001
Private Const HKEY_LOCAL_MACHINE = &H80000002
Private Const HKEY_USERS = &H80000003

'// Windows Error Messages
Private Const ERROR_NONE = 0
Private Const ERROR_BADDB = 1
Private Const ERROR_BADKEY = 2
Private Const ERROR_CANTOPEN = 3
Private Const ERROR_CANTREAD = 4
Private Const ERROR_CANTWRITE = 5
Private Const ERROR_OUTOFMEMORY = 6
Private Const ERROR_INVALID_PARAMETER = 7
Private Const ERROR_ACCESS_DENIED = 8
Private Const ERROR_INVALID_PARAMETERS = 87
Private Const ERROR_NO_MORE_ITEMS = 259

'// Windows Security Messages
Private Const KEY_ALL_ACCESS = &H3F
Private Const REG_OPTION_NON_VOLATILE = 0

'// Windows Registry API calls
Private Declare Function RegCloseKey Lib "advapi32.dll" _
 (ByVal hKey As Long) As Long

Private Declare Function RegCreateKeyEx _
  Lib "advapi32.dll" Alias "RegCreateKeyExA" _
 (ByVal hKey As Long, _
  ByVal lpSubKey As String, _
  ByVal Reserved As Long, _
  ByVal lpClass As String, _
  ByVal dwOptions As Long, _
  ByVal samDesired As Long, _
  ByVal lpSecurityAttributes As Long, _
  phkResult As Long, _
  lpdwDisposition As Long) As Long

Private Declare Function RegOpenKeyEx _
  Lib "advapi32.dll" Alias "RegOpenKeyExA" _
 (ByVal hKey As Long, _
  ByVal lpSubKey As String, _
  ByVal ulOptions As Long, _
  ByVal samDesired As Long, _
  phkResult As Long) As Long

Private Declare Function RegSetValueExString _
  Lib "advapi32.dll" Alias "RegSetValueExA" _
 (ByVal hKey As Long, _
  ByVal lpValueName As String, _
  ByVal Reserved As Long, _
  ByVal dwType As Long, _
  ByVal lpValue As String, _
  ByVal cbData As Long) As Long

Private Declare Function RegSetValueExLong _
  Lib "advapi32.dll" Alias "RegSetValueExA" _
 (ByVal hKey As Long, _
  ByVal lpValueName As String, _
  ByVal Reserved As Long, _
  ByVal dwType As Long, _
  lpValue As Long, _
  ByVal cbData As Long) As Long


Public Sub CreateAssociation(fileEx As String, Discription As String)
  Dim sPath As String

  CreateNewKey fileEx, HKEY_CLASSES_ROOT
  SetKeyValue fileEx, "", Discription, REG_SZ
  CreateNewKey Discription & "\shell\Open in CyberCrypt\command", HKEY_CLASSES_ROOT
  CreateNewKey Discription & "\DefaultIcon", HKEY_CLASSES_ROOT
  SetKeyValue Discription & "\DefaultIcon", "", App.Path & "\" & App.EXEName & ".exe,0", REG_SZ
  SetKeyValue Discription, "", "CyberCrypt file", REG_SZ
  sPath = App.Path & "\" & App.EXEName & ".exe %1"

  SetKeyValue Discription & "\shell\Open in CyberCrypt\command", "", sPath, REG_SZ
End Sub

Private Function SetValueEx(ByVal hKey As Long, _
 sValueName As String, lType As Long, _
 vValue As Variant) As Long

  Dim nValue As Long
  Dim sValue As String

  Select Case lType
    Case REG_SZ
      sValue = vValue & Chr$(0)
      SetValueEx = RegSetValueExString(hKey, _
        sValueName, 0&, lType, sValue, Len(sValue))

    Case REG_DWORD
      nValue = vValue
      SetValueEx = RegSetValueExLong(hKey, sValueName, _
        0&, lType, nValue, 4)

  End Select
End Function

Private Sub CreateNewKey(sNewKeyName As String, _
  lPredefinedKey As Long)

  '// handle to the new key
  Dim hKey As Long

  '// result of the RegCreateKeyEx function
  Dim r As Long

  r = RegCreateKeyEx(lPredefinedKey, sNewKeyName, 0&, _
    vbNullString, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, 0&, hKey, r)

  Call RegCloseKey(hKey)
End Sub

Private Sub SetKeyValue(sKeyName As String, sValueName As String, _
vValueSetting As Variant, lValueType As Long)

  '// result of the SetValueEx function
  Dim r As Long

  '// handle of opened key
  Dim hKey As Long

  '// open the specified key
  r = RegOpenKeyEx(HKEY_CLASSES_ROOT, sKeyName, 0, _
    KEY_ALL_ACCESS, hKey)

  r = SetValueEx(hKey, sValueName, lValueType, vValueSetting)

  Call RegCloseKey(hKey)
End Sub
