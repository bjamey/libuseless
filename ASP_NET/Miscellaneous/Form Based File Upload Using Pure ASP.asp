<!-- --------------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Form Based File Upload Using Pure ASP

   Date : 15/05/2007
   By   : FSL
--------------------------------------------------------------------------- -->

<!--
 Form Based File Upload Using Pure ASP

    '**************************************
    ' Name: Form Based File Upload Using Pur
    '     e ASP
    ' Description:<b>This code will al
    '     low you to do form based file uploads<
    '     ;/b>. It supports multiple files and
    '     uses only pure ASP. It will parse form d
    '     ata, browse server folders for a save lo
    '     cation, and log uploads or failed upload
    '     s into a database There are no component
    '     s to install so it will work on any web
    '     server that supports ASP. Just paste thi
    '     s code into a text file and name it save
    '     any.asp. I have tested it on IIS 4 and 5
    '     , with IE 4, IE 5 and Netscape 6. With t
    '     his code you will be able to save a file
    '     in any directory that the anonymous acco
    '     unt assigned to it (usually IUSER_machin
    '     ename) has access to so be careful. I sh
    '     ould note that the server needs ADO, ADO
    '     X and the File System Object installed o
    '     n it.
    ' By: Karl P. Grear
    '
    'This code is copyrighted and has limited warranties.Please see
    ' http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=6569&lngWId=4
    'for details.
    '**************************************
-->

    <%response.buffer=false
    Func = Request("Func")
    if isempty(Func) Then
            Func = 1
    End if
    Select Case Func
    Case 1
    'You do not need to use this form to
    'send your files.
    BrowseServer = Request.Form("BrowseServer")
    %>
    <H2>File Upload Form.</H2>

            <TABLE>


                    <FORM ENCTYPE="multipart/form-data" ACTION="saveany.asp?func=2" METHOD=POST id=form1 name=form1>
                    <TR><TD><STRONG>Debug Options.</STRONG><BR></TD></TR>
            <TR><TD><INPUT NAME=Options TYPE=CheckBox Value='Raw'>Create Raw File<BR></TD></TR>
                    <TR><TD><INPUT NAME=Options TYPE=CheckBox Value='Boundry'>Create Boundry File<BR><BR></TD></TR>

                    <TR><TD><STRONG>Hit the [Browse Server] button to find the folder on the server to upload to.</STRONG><BR></TD></TR>
                    <TR><TD><INPUT NAME=ServerPath SIZE=30 TYPE=Text value='<%= BrowseServer %>'><INPUT type=button value="Browse Server" onclick="document.location='saveany.asp?func=3'" id=button1 name=button1><BR><BR></TD></TR>

                    <TR><TD><STRONG>Hit the [Browse] button to find the file on your computer.</STRONG><BR></TD></TR>
                    <TR><TD><INPUT NAME=File1 SIZE=30 TYPE=file><BR></TD></TR>
                    <TR><TD><INPUT NAME=File2 SIZE=30 TYPE=file><BR></TD></TR>
                    <TR><TD><INPUT NAME=File3 SIZE=30 TYPE=file><BR><BR></TD></TR>
                    <TR><TD><STRONG>Enter security password.<STRONG><BR></TD></TR>
                    <TR><TD><INPUT NAME=Password SIZE=30 TYPE=Text><BR></TD></TR>
                    <TR><TD><STRONG>Comments<STRONG><BR></TD></TR>
                    <TR><TD><TEXTAREA name=TArea cols=35 rows=5>Enter Comments Here</TEXTAREA><BR></TD></TR>
                    <TR><TD align=left><INPUT name=submit type="submit" value="Upload File"><BR><BR></TD></TR>
                    <TR><TD>NOTE: Please be patient, you will not receive any notification until the file is completely transferred.<BR><BR></TD></TR>
                    </FORM>
            </TABLE>
    <%
    Case 2
    Server.ScriptTimeout=300
    ForWriting = 2
            adLongVarChar = 201
            lngNumberUploaded = 0

    'Create a database connection
            Set conn = server.createobject("adodb.connection")
    'Create a recordset
                    Set rstLog = server.createobject("adodb.recordset")

                    On Error Resume Next
            'Open the connection
                    conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\inetpub\UploadLog.mdb;Persist Security Info=False"
                    if err.number = "-2147467259" Then
                            'the database is missing create it
                            CreateDatabase
                            Response.Write "Create Database"
                            'reopen the connetion
                            conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\inetpub\UploadLog.mdb;Persist Security Info=False"
                            err.clear
                    End if

            'Open recordset
                    rstLog.Open "Select * from Logs", conn, 3, 3, 1

    'Get binary data from form
            noBytes = Request.TotalBytes
            binData = Request.BinaryRead (noBytes)

    'convery the binary data to a string
            Set RST = CreateObject("ADODB.Recordset")
            LenBinary = LenB(binData)

            if LenBinary > 0 Then
                    RST.Fields.Append "myBinary", adLongVarChar, LenBinary
                    RST.Open
                            RST.AddNew
                                    RST("myBinary").AppendChunk BinData
                            RST.Update
                    strDataWhole = RST("myBinary")
            End if


            'get the boundry indicator
                    strBoundry = Request.ServerVariables ("HTTP_CONTENT_TYPE")
                    lngBoundryPos = instr(1,strBoundry,"boundary=") + 8
                    strBoundry = "--" & right(strBoundry,len(strBoundry)-lngBoundryPos)

            'ParseForm returns a dictionary object
            'You can ParseForm any time after the
            'Boundry indicator is set.

            Set dPassword = ParseForm("Password")
            Set dOptions = ParseForm("Options")

                    'both of these are valid
                    Response.Write ParseForm("Password").item(0) & "<BR>"
                    Response.write dPassword.item(0) & "<BR>"

                    'Just write the data In the TArea
                    response.Write ParseForm("TArea").item(0) & "<BR>"

                    SavePath = ParseForm("ServerPath").item(0)
                    if SavePath = "" or isempty(SavePath) Then
                            Response.Write "<H2> The following Error occured.</H2>"
                    Response.Write "You did Not enter a server path To save your file to."
                    Response.Write "<BR><BR>Hit the back button, make the needed corrections and resubmit your information."
                    Response.Write "<BR><BR><INPUT type='button' onclick='history.go(-1)' value='<< Back' id='button'1 name='button'1>"
                    Response.End
                    End if

                    intCount = dOptions.count

                    if intCount > 0 Then
                            For x = 0 To intCount
                                    Select Case dOptions.item(x)
                                            Case "Raw"
                                                    Raw = True
                                            Case "Boundry"
                                                    Boundry = True
                                    End Select
                            Next
                    Else
                            Raw = False
                            Boundry = False
                    End if

                    if dPassword.item(0) <> "oktosend" Then
                    'Log invalid attempt To log file.
                            rstLog.AddNew
                    'Log the Date and time, the IP, the Path
                            rstLog(0) = Now()
                            rstLog(1) = request.ServerVariables("REMOTE_ADDR")
                            rstLog(2) = SavePath
                            rstLog(3) = "Invalid Logon"

                            rstLog.Update

                            Response.Write "<H2> The following Error occured.</H2>"
                            Response.Write "The Password you entered is invalid."
                            Response.Write "<BR><BR>Hit the back button, make the needed corrections and resubmit your information."
                            Response.Write "<BR><BR><INPUT type='button' onclick='history.go(-1)' value='<< Back' id='button'1 name='button'1>"
                            Response.End
                    End if
            'Creates a raw data file For With all
    'data sent. Uncomment for debuging.
                    if Raw Then
                    Set fso = CreateObject("Scripting.FileSystemObject")
                            Set f = fso.OpenTextFile(SavePath & "\raw.txt", ForWriting, True)
                            f.Write strDataWhole
                    Set f = nothing
                    Set fso = nothing
                    End if

    'Get first file boundry positions.
    lngCurrentBegin = instr(1,strDataWhole,strBoundry)
    lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1



    countloop = 0

    Do While lngCurrentEnd > 0
    'Get the data between current boundry
    'and remove it from the whole.
    strData = mid(strDataWhole,lngCurrentBegin, (lngCurrentEnd - lngCurrentBegin) + 1)
    'Remove the file data from the whole
                    'strDataWhole = replace(strDataWhole,strData,"")


    'Get the full path of the current file.
            lngBeginFileName = instr(1,strdata,"filename=") + 10
            lngEndFileName = instr(lngBeginFileName,strData,chr(34))
    'Make sure they selected at least one
    'file.
            if lngBeginFileName = lngEndFileName and lngNumberUploaded = 0 Then

                            Response.Write "<H2> The following Error occured.</H2>"
                            Response.Write "You must Select at least one file To upload"
                            Response.Write "<BR><BR>Hit the back button, make the needed corrections and resubmit your information."
                            response.Write "<BR><BR><INPUT type='button' onclick='history.go(-1)' value='<< Back' id='button'1 name='button'1>"
                            Response.End
            End if
    'There could be one or more empty file b
    '
    '
    ' oxes.
            if lngBeginFileName <> lngEndFileName and lngBeginFileName - 10 <> 0 Then
                    strFilename = mid(strData,lngBeginFileName,lngEndFileName - lngBeginFileName)
    'Creates a raw data file with data
    'between current boundrys. Uncomment
    'for debuging.
                    if Boundry Then
                    Set fso = CreateObject("Scripting.FileSystemObject")
                    Set f = fso.OpenTextFile(SavePath & "\raw_" & lngNumberUploaded & ".txt", ForWriting, True)
                            f.Write strData
                    Set f = nothing
                    Set fso = nothing
                    End if

    'Loose the path information and keep
    'just the file name.
                    tmpLng = instr(1,strFilename,"\")
                    Do While tmpLng > 0
                            PrevPos = tmpLng
                            tmpLng = instr(PrevPos + 1,strFilename,"\")
                    Loop

                    FileName = right(strFilename,len(strFileName) - PrevPos)

    'Get the begining position of the file
    'data sent.
    'if the file type is registered with
    'the browser then there will be a
    'Content-Type
                    lngCT = instr(1,strData,"Content-Type:")

                    if lngCT > 0 Then
                            lngBeginPos = instr(lngCT,strData,chr(13) & chr(10)) + 4
                    Else
                            lngBeginPos = lngEndFileName
                    End if
    'Get the ending position of the file
    'data sent.
                    lngEndPos = len(strData)

    'Calculate the file size.
                    lngDataLenth = (lngEndPos - lngBeginPos) -1
    'Get the file data
                    strFileData = mid(strData,lngBeginPos,lngDataLenth)
    'Create the file.
                    Set fso = CreateObject("Scripting.FileSystemObject")
                    Set f = fso.OpenTextFile(SavePath & "\" & FileName, ForWriting, True)
                    f.Write strFileData
                    Set f = nothing
                    Set fso = nothing

                    'Log Upload Informatoin.
                            rstLog.AddNew
                            'Log the Date and time, the IP, the Path, and the Filename
                                    rstLog(0) = Now()
                                    rstLog(1) = request.ServerVariables("REMOTE_ADDR")
                                    rstLog(2) = SavePath
                                    rstLog(3) = FileName

                            rstLog.Update


                            if lngNumberUploaded = 0 Then
                                    Response.Write "<STRONG>Saving Files...</STRONG><BR><BR>"

                            End if

                    Response.Write SavePath & "\" & FileName & "<BR>"


                    lngNumberUploaded = lngNumberUploaded + 1

            End if

    'Get then next boundry postitions if
    'any.
            lngCurrentBegin = lngCurrentEnd
            lngCurrentEnd = instr(lngCurrentBegin + 9 ,strDataWhole,strBoundry) - 1

            'Prevents infinate loop.
                    countloop = countloop + 1
                    if countloop = 100 Then
                            Response.Write "looped 100 times terminating script!"
                            'Close the Log
                            if rstLog.State Then rstLog.close
                            if conn.State Then conn.Close

                            Response.End
                    End if
    loop
            'Close the Log
                    if rstLog.State Then rstLog.close
                    if conn.State Then conn.Close

                    Response.Write "<STRONG>" & lngNumberUploaded & " File(s) Uploaded</STRONG>"
                    Response.Write "<BR><BR><INPUT type='button' onclick='document.location=" & chr(34) & "saveany.asp" & chr(34) & "' value='<< Back to Upload' id='button'1 name='button'1>"
            Case 3

                    'get prev path if any
                    path = Request.QueryString("Path")
                    'if Not assign one
                    if path = "" or isempty(path) Then
                            path = server.MapPath(".")'"c:\inetpub"
                    End if
                    'create filesystemobject
                    Set fso = CreateObject("Scripting.FileSystemObject")
                    'get a folder object
                    Set f = fso.GetFolder(path)
                    path = f.path

                    'limit access To hard drive
                    'if lcase(left(path,10)) <> "c:\inetpub" Then
                    '        path = "C:\Inetpub"
                    '        Set f = fso.GetFolder(path)
                    '        path = f.path
                    'End if

                    Response.Write "<H2>Server Browse Form.</H2>"
                    Response.Write "<FORM ACTION='saveany.asp?func=1' METHOD=POST>"
                    Response.Write "<TABLE width=400 border=1 cellpadding=0 cellspacing=1>" & vbcrlf
                    Response.Write "<TR><TH colspan=2>" & path & "</TH></TR>"
                    Response.Write "<TR><TD colspan=2 align=left><A href='saveany.asp?func=3&path=" & path & "\..'><STRONG>Parent ..</STRONG></A></TD></TR>" & vbcrlf

                    'get subfolders collection
                    Set fc = f.subfolders

                    'enum subfolders
                    For Each folder In fc
                            Response.Write "<TR><TD align=left><INPUT NAME=BrowseServer TYPE=CheckBox Value='" & folder.path & "'></TD><TD style='padding-left: 20px;' align=left><A href='saveany.asp?func=3&path=" & folder.path & "'>" & folder.name & "</A></TD></TR>" & vbcrlf
                    Next

                    'if there is a folder display the Select folder button
                            if fc.count > 0 Then
                                    Response.Write "<TR><TD align=left colspan=2><BR><INPUT name=submit type='submit' value='Select Folder'></TD></TR>"
                            End if

                            Response.Write"<TR><TD colspan=2><INPUT name=cancel type='Button' value='Cancel' onclick=document.location='saveany.asp?func=1'></TD></TR>"

                    Response.Write "</TABLE>" & vbcrlf
                    Response.Write "</FORM>"
    End Select

    %>
    </BODY>
    </HTML>
    <SCRIPT LANGUAGE=vbscript RUNAT=Server>
            function ParseForm(strFieldName)

                    Set strFormData = CreateObject("Scripting.Dictionary")
                    lngCount = -1
                    'Try To find the Field
                    lngNamePos = instr(1,strDataWhole,"name=" & chr(34) & strFieldName & chr(34))

                    'Parse through data In search of fields
                            Do While lngNamePos <> 0
                                    lngCount = lngCount + 1
                                    lngBeginFieldData = instr(lngNamePos,strDataWhole,vbcrlf & vbcrlf)+4
                                    lngEndFieldData = instr(lngBeginFieldData,strDataWhole,strBoundry)-2
                                    strFormData.Add lngCount, mid(strDataWhole,lngBeginFieldData,lngEndFieldData-lngBeginFieldData)
                                    lngNamePos = instr(lngEndFieldData,strDataWhole,"name=" & chr(34) & strFieldName & chr(34))

                            Loop
                            Set ParseForm = strFormData
            End function

            function CreateDatabase
                            'on Error Goto 0
            'create an instance of a catalog(Database)
                    Set cat = server.createobject("ADOX.Catalog")
            'create the catalog
                            cat.Create ("Provider='Microsoft.Jet.OLEDB.4.0';Data Source='c:\inetpub\UploadLog.mdb'")
                            Set connNew = cat.ActiveConnection
                            connNew.CursorLocation = 3
                    'get the Connection and add a Table and the following fields
                            connNew.execute "Create Table [Logs]"
                            connNew.execute "Alter Table [Logs] Add Column [DateTimeStamp] DATETIME"
                            connNew.execute "Alter Table [Logs] Add Column [IP Address] TEXT(15)"
                            connNew.execute "Alter Table [Logs] Add Column [Path] TEXT(100)"
                            connNew.execute "Alter Table [Logs] Add Column [File] TEXT(100)"
                            connNew.execute "Alter Table [Logs] Add Column [Notes] MEMO"
                    'clean up
                            connNew.close
                            Set connNew = nothing
                            Set cat = nothing
            End function

    </SCRIPT>
