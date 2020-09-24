' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retrieving Environmental Details
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' 1) Place a button in the form
' 2) Place a TextBox in the Form and name it as txtInfo
' 3) Set the Multi-line property of the TextBox(txtInfo) to True
' 4) Import the System.Environment namespace
' 5) Write the following code in the CommandButton click Event

        Dim s As String
        Dim o As System.Environment

        s = "Current Directory=System.Environment.CurrentDirectory()->"
        s = s & o.CurrentDirectory() & vbCrLf

        s = s & "CommandLine=System.Environment.CommandLine()->"
        s = s & o.CommandLine() & vbCrLf

        s = s & "Environment Variable=System.Environment.GetEnvironmentVariable(variable)->"
        s = s & o.GetEnvironmentVariable("PATH") & vbCrLf

        s = s & "MachineName=System.Environment.MachineName->"
        s = s & o.MachineName & vbCrLf

        s = s & "SystemDirectory=System.Environment.SystemDirectory->"
        s = s & o.SystemDirectory & vbCrLf

        s = s & "UserName=System.Environment.UserName->"
        s = s & o.UserName & vbCrLf

        s = s & "UserDomainName=System.Environment.UserDomainName->"
        s = s & o.UserDomainName & vbCrLf

        s = s & "OSVersion=System.Environment.OSVersion->"
        s = s & o.OSVersion.ToString & vbCrLf

  txtInfo.Text = s

' The namespace System.Environment provides methods  to access various information like System Name, Domain Name , Username, OSVersion etc. These methods returns a string as a parameter. Values are retrieved and stored in the local variable s. To avoid using a length qualifier System.Environment with each call, a varaible is declared of type System.Environment and the same is substituted there.

' When the button is pressed, all the above information  are retrieved and posted in the Textbox txtInfo.

' Happy programming with VB.NET.
