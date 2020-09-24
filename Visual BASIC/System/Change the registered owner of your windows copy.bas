' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Change the registered owner of your windows copy
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Const HKEY_LOCAL_MACHINE = &H80000002

Private Declare Function RegCreateKey Lib _
   "advapi32.dll" Alias "RegCreateKeyA" _
   (ByVal Hkey As Long, ByVal lpSubKey As _
   String, phkResult As Long) As Long

Private Declare Function RegCloseKey Lib _
   "advapi32.dll" (ByVal Hkey As Long) As Long

Private Declare Function RegSetValueEx Lib _
   "advapi32.dll" Alias "RegSetValueExA" _
   (ByVal Hkey As Long, ByVal _
   lpValueName As String, ByVal _
   Reserved As Long, ByVal dwType _
   As Long, lpData As Any, ByVal _
   cbData As Long) As Long

Private Const REG_SZ = 1
Private Const REG_DWORD = 4


' --------------
' Code
' --------------

Public Function ChangeWindowsOwner(OwnerName As String, _
 Organization As String) As Boolean
    On Error GoTo ErrorHandler

    Dim bAns As Boolean

    If OwnerName = "" Or Organization = "" Then
       ChangeWindowsOwner = False
       Exit Function
    End If

    bAns = SaveString(HKEY_LOCAL_MACHINE, _
          "Software\Microsoft\Windows\CurrentVersion", _
          "RegisteredOwner", OwnerName)

    If bAns Then bAns = SaveString(HKEY_LOCAL_MACHINE, _
          "Software\Microsoft\Windows\CurrentVersion", _
          "RegisteredOrganization", Organization)

    ChangeWindowsOwner = bAns

    Exit Function

ErrorHandler:
    ChangeWindowsOwner = False
End Function

Private Function SaveString(Hkey As Long, strPath As String, _
strValue  As String, strdata As String) As Boolean

   Dim keyhand As Long
   Dim r As Long

   r = RegCreateKey(Hkey, strPath, keyhand)
   r = RegSetValueEx(keyhand, strValue, 0, _
      REG_SZ, ByVal strdata, Len(strdata))
   r = RegCloseKey(keyhand)

   SaveString = (r = 0)
End Function
