' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Return Value from Stored Procedure
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

<%@ Page Language="VB" EnableSessionState="False" EnableViewState="False"

Trace="False"

Debug="False" Strict="True" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SQLClient" %>

<script language="VB" runat="server">

Sub Page_Load(Sender As Object, E As EventArgs)

Dim myConnection As SqlConnection = _
New SqlConnection(ConfigurationSettings.AppSettings("DSN"))

Dim MyCommand as SQLCommand = New SQLCommand("spReturnarticleId", MyConnection)
MyCommand.CommandType = CommandType.StoredProcedure
myConnection.Open()

'Execute the Stored Procedure, return the value and increment it by 1



Dim count As Int32 = CInt(myCommand.ExecuteScalar()) + 1



dim strID as string = cstr(count)

'Set the value of a textbox

text1.text = strId

'Set the Value of a message to test what value is returned

Message.InnerHtml = strId

myConnection.Close()

End Sub

</script>
<html>


<head></head>

<body>
<h1 align="center">Article Info</h1>

<span id="Message" style="font: arial 11pt;color:#339900;" runat="server"/></h2>

<asp:textbox id="text1" size="20" runat="server" />

</body>
</html>
