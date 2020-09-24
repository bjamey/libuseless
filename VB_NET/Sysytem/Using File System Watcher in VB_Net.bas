' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Using File System Watcher in VB·Net
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Imports System.IO

Class FileWatch

  Shared Sub main()
    Dim file_watch As New FileSystemWatcher()

    ' Path to monitor
    file_watch.Path = "c:\"

    ' Uncomment to watch files
    ' file_watch.Target = IO.WatcherTarget.File

    file_watch.IncludeSubdirectories = True

    ' Additional filtering
    file_watch.Filter = "*.*"
    file_watch.EnableRaisingEvents = true

    'Add the event handler for creation of new files only
    AddHandler file_watch.created, New FileSystemEventHandler(AddressOf OnFileEvent)

    ' file_watch.Enabled = True

    ' Dont Exit
    console.readline()
  End Sub

  ' Event that will be raised when a new file is created
  Shared Sub OnFileEvent(ByVal source As Object, ByVal e As FileSystemEventArgs)
       console.writeline("New File Created in C: ")
  End Sub

End Class                         
