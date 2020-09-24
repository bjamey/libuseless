' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Show File Properties Dialog
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Explicit

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Const SEE_MASK_INVOKEIDLIST As Long = &HC
Private Const SEE_MASK_NOCLOSEPROCESS As Long = &H40
Private Const SEE_MASK_FLAG_NO_UI As Long = &H400

Private Type SHELLEXECUTEINFO
    cbSize As Long
    fMask As Long
    hwnd As Long
    lpVerb As String
    lpFile As String
    lpParameters As String
    lpDirectory As String
    nShow As Long
    hInstApp As Long
    lpIDList As Long
    lpClass As String
    hkeyClass As Long
    dwHotKey As Long
    hIcon As Long
    hProcess As Long
End Type

Private Declare Function ShellExecuteEx Lib "shell32.dll" (SEI As SHELLEXECUTEINFO) As Long


' ----------
' Function
' ----------

Public Sub ShowFileProperties(ByVal FileName As String, ByVal OwnerhWnd As Long)
    On Error Resume Next

    Dim SEI As SHELLEXECUTEINFO
    Dim R As Long
    With SEI
        'Set the structure's size
        .cbSize = Len(SEI)
        'Seet the mask
        .fMask = SEE_MASK_NOCLOSEPROCESS Or _
         SEE_MASK_INVOKEIDLIST Or SEE_MASK_FLAG_NO_UI
        'Set the owner window
        .hwnd = OwnerhWnd
        'Show the properties
        .lpVerb = "properties"
        'Set the filename
        .lpFile = FileName
        .lpParameters = vbNullChar
        .lpDirectory = vbNullChar
        .nShow = 0
        .hInstApp = 0
        .lpIDList = 0
    End With

    R = ShellExecuteEx(SEI)
End Sub
