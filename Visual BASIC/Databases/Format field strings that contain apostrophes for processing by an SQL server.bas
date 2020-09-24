' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Format field strings that contain apostrophes for processing by an SQL server
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Function FormatSQL(StrFieldVal As String) As String
    ' Format Apostrophes For SQL Statement

    Dim ChrPos As Long, PosFound As Long
    Dim WrkStr As String

    For ChrPos = 1 To Len(StrFieldVal)
        PosFound = InStr(ChrPos, StrFieldVal, "'")

        If PosFound > 0 Then
            WrkStr = WrkStr & Mid(StrFieldVal, ChrPos, PosFound - ChrPos + 1) & "'"
            ChrPos = PosFound
        Else
            WrkStr = WrkStr & Mid(StrFieldVal, ChrPos, Len(StrFieldVal))
            ChrPos = Len(StrFieldVal)
        End If
    Next ' ChrPos

    FormatSQL = WrkStr
End Function
