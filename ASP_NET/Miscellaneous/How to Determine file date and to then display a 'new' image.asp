<!-- --------------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How to Determine file date and to then display a 'new' image

   Date : 24/05/2007
   By   : FSL
--------------------------------------------------------------------------- -->

<!%@ Import Namespace="system.IO" %>
<!%@ Register TagPrefix="Top" TagName="TopStuff" Src="toppage.ascx" %>
<!%@ Register TagPrefix="Bottom" TagName="BottomStuff" Src="bottompage.ascx" %>
<!script language="vb" runat="server">

Sub Page_Load(Sender as Object, E as EventArgs)
   ...This code tip reads in a directory of files, determines if the file date not older than 180 days and displays various image's. This builds a string and passes it to a Literal control.
[code]
<%@ Import Namespace="system.IO" %>
<%@ Register TagPrefix="Top" TagName="TopStuff" Src="toppage.ascx" %>
<%@ Register TagPrefix="Bottom" TagName="BottomStuff" Src="bottompage.ascx" %>
<script language="vb" runat="server">

Sub Page_Load(Sender as Object, E as EventArgs)
    Dim dir As DirectoryInfo = New DirectoryInfo("d:webrootbigdogs")
    Dim files As FileInfo() = dir.GetFiles()
    Dim count As Integer = files.Length
    Dim i As Integer
    dim daFiles as string
For i = 0 To count - 1
    Dim theDate As Integer = DateDiff(DateInterval.Day, files(i).CreationTime, Date.Today)
        If theDate < 180 Then
            daFiles = daFiles & "<li><img src=new.gif'><a href='" & files(i).Name & "'>" & files(i).Name & "</a></li>"
        Else
            daFiles = daFiles & "<li><a href='" & files(i).Name & "'>" & files(i).Name & "</a></li>"
        End If
Next

jokes.Text = "</ul>" & daFiles
End Sub
</script>
<html>
    <head>
        <title>Big Dogs</title>
    </head>
    <body background="/images/pawsback.gif">
<Top:TopStuff TitleOfDemo=" list new Gif File" runat="server" />

<asp:Literal id="jokes" runat="server" />

<bottom:bottomstuff runat="server" />

    </body>
</html>
