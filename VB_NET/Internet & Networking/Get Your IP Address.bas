' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get Your IP Address
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Strict Off
imports system
Imports System.Net.DNS


Public Class GetIP
        shared Function GetIPAddress() As String
                Dim oAddr As System.Net.IPAddress
                Dim sAddr As String

                With system.Net.DNS.GetHostByName(system.Net.DNS.GetHostName())
                        oAddr = New System.Net.IPAddress(.AddressList(0).Address)
                        sAddr = oAddr.ToString
                End With
                GetIPAddress = sAddr
        End Function

        shared Sub main
                Dim shostname As String

                'Set string equal to value of System DNS Object value for GetHostName
                'This should be the localhost computer name
                shostname = system.Net.DNS.GetHostName
                console.writeline ("Your Machine Name = " & shostname )

                'Call Get IPAddress
                console.writeline ("Your IP = " & GetIPAddress )
        End Sub
End Class
