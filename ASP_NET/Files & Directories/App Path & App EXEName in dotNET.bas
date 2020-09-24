' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: App Path & App EXEName in dotNET
' 
'  Date : 15/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'**************************************
' Name: App.Path & App.EXEName
' Description:As .Net does Not include App object as in VB here is a solution for App.Path and App.ExeName
' By: Pankaj Nagar
'
'
' Inputs:None
'
' Returns:App.Path and App.EXEName
'
'Assumes:Just add this class in your application and use it
'
'Side Effects:None
'**************************************

Option Explicit
Option Strict

Imports System
Imports System.IO

Class ThisApp
      Private mAppPath As String
      Private mExeName As String
      Public ReadOnly Property AppPath() As String
              Get
                 Return mAppPath
              End Get
      End Property

      Public ReadOnly Property ExeName() As String
              Get
                 Return mExeName
              End Get
      End Property

      Public Sub New()
              Dim p As Path
              Try
                  mAppPath = System.Reflection.Assembly.GetExecutingAssembly.Location
                  mExeName = Dir(mAppPath)
                  mAppPath = p.GetFullPath((Left(mAppPath, (Len(mAppPath) - Len(mExeName)))))
              Catch
                   MsgBox(Err.Description, MsgBoxStyle.Critical, "Error!")
              End Try
      End Sub
End Class

Module modMain
    Sub Main()
            Dim MyApp As ThisApp = New ThisApp()
            MsgBox(MyApp.AppPath, MsgBoxStyle.Information, "App Path")
            MsgBox(MyApp.ExeName, MsgBoxStyle.Information, "Exe Name")
    End Sub
End Module
