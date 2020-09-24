' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Open, View, Close a Powerpoint Presentation File
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ------------------------------------------------------------- '
' Note:
' Add Microsoft Powerpoint object library reference
' This code snippet come from Microsoft Office Development site
' ------------------------------------------------------------- '


' ---------
' Functions
' ---------


Sub OpenPresentation(strFilename As String)
    ' strFilename = Powerpoint Presentation File

    Dim oPPT As PowerPoint.Application
    Set oPPT = New PowerPoint.Application


    ' Open a powerpoint file
    With oPPT
        .Visible = True
        .Presentations.Open (strFilename)
        .Presentations(strFilename).Close
    End With

    ' View the slide show

    ' Sleep 500
    With oPPT.ActivePresentation.SlideShowSettings
        .AdvanceMode = ppSlideShowUseSlideTimings
        .Run
    End With


    ' Wait until there are no more slide show windows and then quit Powerpoint
    Do
      Sleep 1000
    Loop While oPPT.SlideShowWindows.Count > 0

    oPPT.Quit
    Set oPPT = Nothing
End Sub
