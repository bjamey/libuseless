' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Create an XML on the fly from a Dataset
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

<%@ Page EnableSessionState="False" EnableViewState="False" debug="False" trace="False" strict="True" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SQLClient" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>

<script language=VB runat=server>
'Path where the xml file will be created
private const m_XmlFile as String = "c:\inetpub\wwwroot\newfile.xml"

Sub Page_Load(Sender As Object, E As EventArgs)

'Create Connection and DataSet Objects
Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("DSN_pubs"))
Dim ds as DataSet = new DataSet()
dim sSql as string = "SELECT * FROM Authors"

'Declare an Adapter and Fill Dataset
dim adapter as SqlDataAdapter = new SqlDataAdapter(sSql, myConnection)
adapter.Fill(ds,"WhatsNew")
myConnection.Close()

'One line of code to create an xml file
ds.WriteXml(m_XmlFile, XmlWriteMode.IgnoreSchema)

End Sub

</script>
<html>
<head></head>
<body>

File Created!

</body>
</html>
