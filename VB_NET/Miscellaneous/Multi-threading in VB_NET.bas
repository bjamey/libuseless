' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Multi-threading in VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Imports System.Threading
Public Module ThreadSample
    Public Balance As Integer = 1000
    Sub Main()
        Dim account As Account = New Account()
        Dim depositeBalance1 As DepositeBalance = New _
                DepositeBalance(account, 1000, "Customer 1")
        Dim depositeBalance2 As DepositeBalance = New _
           DepositeBalance(account, 1000, "Customer 2")
        Dim t1 As Thread = New _
             Thread(AddressOf depositeBalance1.DepositeAmount)
        Dim t2 As Thread = New _
        Thread(AddressOf depositeBalance2.DepositeAmount)
        t1.Start()
        t2.Start()
        Try
            t1.Join()
            t2.Join()
        Catch e As Exception
            Console.Write(e.ToString())
        Finally
            'Do Nothing
        End Try
    End Sub
    Public Class Account
        Private balanceAmount As Integer
        Public Sub Deposite(ByVal amount As Integer, _
            ByVal message As String)
            Console.Write(message & _
                " Depositing Amount " & amount)
            Console.Write(message & " Checking Previous Balance")
            Monitor.Enter(Me)
            balanceAmount = getBalance()
            Console.Write(message & _
                " Previous Balance in Account " & balanceAmount)
            balanceAmount += amount
            Console.Write(message & _
               " Updating Balance in Account ")
            setBalance(balanceAmount)
            Monitor.Exit(Me)
            Console.Write(message & " Update Balance " & Balance)

        End Sub
        Private Function getBalance() As Integer
            Try
                Thread.sleep(1000)
            Catch e As Exception
                Console.Write(e.ToString())
            Finally
                'Do Nothing
            End Try
            Return Balance
        End Function

        Private Sub setBalance(ByVal amount As Integer)
            Try
                Thread.sleep(1000)
            Catch e As Exception
                Console.Write(e.ToString())
            Finally
                'Do Nothing
            End Try
            Balance = amount
        End Sub
    End Class

    Public Class DepositeBalance
        Private account As Account
        Private amount As Integer
        Private message As String

        Public Sub new(ByRef account As Account, _
         ByVal amount As Integer, ByVal message As String)
            MyBase.New()
            Me.account = account
            Me.amount = amount
            Me.message = message
        End Sub
        Public Sub DepositeAmount()
            Account.Deposite(amount, message)
        End Sub
    End Class
End Module
