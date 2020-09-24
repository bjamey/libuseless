' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: File Manipulation Functions in VB dotNET (no API used)
'
' Date : 15/05/2007
' By   : FSL
' -----------------------------------------------------------------------------

'**************************************
' Name: Basic File Functions - Its Easy
' Description:File Manipulation Functions. No API
' By: Pankaj Nagar
'
'
' Inputs:None
'
' Returns:Depends
'
'Assumes:None
'
'Side Effects:None
'**************************************

' Basic File Functions
' ---------------------

' ---------
' Read File
' ---------
Imports System
Imports System.IO

Public Module modmain
    Sub Main()
        Dim srFile as StreamReader = File.OpenText("C:\autoexec.bat")
        Console.WriteLine(srFile.ReadToEnd())
        srFile.Close
    End Sub
End Module


' ----------
' Write File
' ----------
Imports System
Imports System.IO

Public Module modmain
       Sub Main()
           Dim swFile as StreamWriter = File.CreateText("C:\test.txt")
           swFile.WriteLine("Hello World ;)")
           swFile.Flush()
           swFile.Close()
       End Sub
End Module

' -----------------
' File Version Info
' -----------------
Imports System
Imports System.Diagnostics

Public Module modmain
       Sub Main()
           Dim versionInfo As FileVersionInfo = FileVersionInfo.GetVersionInfo("C:\WINNT\Notepad.exe")
           Console.WriteLine("Notepad version " + versionInfo.FileVersion)
           Console.WriteLine("Description: " + versionInfo.FileDescription)
       End Sub
End Module


' ---------
' File Size
' ---------
Imports System
Imports System.IO

Public Module modmain
       Sub Main()
           Dim MyFile as new FileInfo ("c:\autoexec.bat")
           Console.WriteLine("The length of autoexec.bat is " _
           + MyFile.Length.ToString + " bytes.")
       End Sub
End Module


' -------------------------
' Copy Move and Delete File
' -------------------------
Imports System
Imports System.IO

Public Module modmain
       Sub Main()
           File.Copy("c:\autoexec.bat", "c:\autocopy.ext")
           File.Move("c:\autocopy.ext", "c:\newname.ext")
           File.Delete("c:\autocopy.ext")
       End Sub
End Module

' -------------------
' Temporary File Name
' -------------------
' The GetTempFileName function creates a name for a temporary file. The filename
' is the concatenation of specified path and prefix strings, a hexadecimal string
' formed from a specified integer, and the .TMP extension.
Imports System
Imports System.IO

Public Module modmain
       Sub Main()
           Console.WriteLine(Path.GetTempFileName)
       End Sub
End Module
