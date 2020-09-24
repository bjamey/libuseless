' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get the windows font directory
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetWindowsFontDir
'
' Calls the windows API to get the windows font directory
' and ensures that a trailing dir separator is present
'
' Returns: The windows font directory
'-----------------------------------------------------------
'
Function GetWindowsFontDir() As String
    Dim oMalloc As IVBMalloc
    Dim sPath   As String
    Dim IDL     As Long

    ' Fill the item id list with the pointer of each folder item, rtns 0 on success
    If SHGetSpecialFolderLocation(0, sfidFONTS, IDL) = NOERROR Then
        sPath = String$(gintMAX_PATH_LEN, 0)
        SHGetPathFromIDListA IDL, sPath
        SHGetMalloc oMalloc
        oMalloc.Free IDL
        sPath = StringFromBuffer(sPath)
    End If
    AddDirSep sPath

    GetWindowsFontDir = sPath
End Function
