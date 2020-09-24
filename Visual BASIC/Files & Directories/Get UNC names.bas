' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get UNC names
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'-----------------------------------------------------------
' FUNCTION: GetUNCShareName
'
' Given a UNC names, returns the leftmost portion of the
' directory representing the machine name and share name.
' E.g., given "\\SCHWEIZ\PUBLIC\APPS\LISTING.TXT", returns
' the string "\\SCHWEIZ\PUBLIC"
'
' Returns a string representing the machine and share name
'   if the path is a valid pathname, else returns NULL
'-----------------------------------------------------------
'
Function GetUNCShareName(ByVal strFN As String) As Variant
    GetUNCShareName = Null

    If IsUNCName(strFN) Then
        Dim iFirstSeparator As Integer

        iFirstSeparator = InStr(3, strFN, gstrSEP_DIR)

        If iFirstSeparator > 0 Then
            Dim iSecondSeparator As Integer

            iSecondSeparator = InStr(iFirstSeparator + 1, strFN, gstrSEP_DIR)
            If iSecondSeparator > 0 Then
                GetUNCShareName = Left$(strFN, iSecondSeparator - 1)
            Else
                GetUNCShareName = strFN
            End If
        End If
    End If
End Function                  
