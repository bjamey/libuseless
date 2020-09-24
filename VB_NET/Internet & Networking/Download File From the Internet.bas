' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Download File From the Internet
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Dim wClient As Net.WebClient = New Net.WebClient

Dim theAddy As String = "http://www.vbcodesource.com/dummyFile.txt"

wClient.DownloadFile(theAddy, "c:\dummy.txt")
