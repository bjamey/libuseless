' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Sending Email using a Formatted Text Editor
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Button1.Attributes.Add("onClick", "javascript:fillTxt();")
Dim attach1 As String = ""
Dim strFileName As String = ""
Dim message As New MailMessage()
If (attachFile1.PostedFile.FileName <> "") Then
Dim ulFile As HttpPostedFile = attachFile1.PostedFile
     Dim nFileLen As Int64 = ulFile.ContentLength
     If (nFileLen > 0) Then
strFileName= Path.GetFileName(attachFile1.PostedFile.FileName)
             strFileName = "Uploads/" + strFileName
attachFile1.PostedFile.SaveAs(Server.MapPath(strFileName))
Dim attach As MailAttachment = New MailAttachment(Server.MapPath(strFileName))
                message.Attachments.Add(attach)
                attach1 = strFileName
      End If
End If
        message.From = TextBox2.Text
        message.To = TextBox3.Text
        message.Cc = txtcc.Text
        message.Bcc = txtbcc.Text
        message.Subject = TextBox4.Text
        message.Body = hdnmsg.Value
        message.BodyFormat = MailFormat.Html
  SmtpMail.SmtpServer = "127.0.0.1"
    SmtpMail.Send(message)
lblMessage.Text = "Your email has been sent"
