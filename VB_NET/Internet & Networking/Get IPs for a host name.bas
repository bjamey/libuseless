' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get IPs for a host name
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Get the IP addresses for a given domain name

Private Function GetAllIPAddresses(ByVal domainName As String) _
        As System.Collections.Specialized.StringCollection

    Dim results As New System.Collections.Specialized.StringCollection
    Dim hostInfo As System.Net.IPHostEntry = System.Net.Dns.GetHostByName(domainName)

    For Each ip As System.Net.IPAddress In hostInfo.AddressList
        results.Add(ip.ToString)
    Next

    Return results
End Function
