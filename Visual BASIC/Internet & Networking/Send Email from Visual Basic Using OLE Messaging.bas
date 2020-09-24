' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Send Email from Visual Basic Using OLE Messaging
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------------------------------
' Notes :
'
' On the Tools menu, choose References and select the
' Microsoft CDO 1.21 Library
' ----------------------------------------------------



' ----------
' Code
' ----------


Private Sub Send_Email(Subject As String, MessageText As String, RecipientName As String)
  Dim objSession As Object
  Dim objMessage As Object
  Dim objRecipient As Object


  ' Create the Session Object
  Set objSession = CreateObject("mapi.session")


  ' Logon using the session object
  ' Specify a valid profile name if you want to
  ' Avoid the logon dialog box
  objSession.Logon profileName:="MS Exchange Settings"


  ' Add a new message object to the OutBox
  Set objMessage = objSession.Outbox.Messages.Add


  ' Set the properties of the message object
  objMessage.subject = Subject
  objMessage.Text = MessageText


  'Add a recipient object to the objMessage.Recipients collection
  Set objRecipient = objMessage.Recipients.Add


  'Set the properties of the recipient object
  objRecipient.Name = RecipientName

  objRecipient.Type = mapiTo
  objRecipient.Resolve

  'Send the message
  objMessage.Send showDialog := False

  MsgBox "Message sent successfully!"

  ' Logoff using the session object
  objSession.Logoff
End Sub
