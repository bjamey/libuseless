' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Find free disk space on a computer
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------


Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceA" (ByVal lpRootPathName As String, lpSectorsPerCluster As Long, lpBytesPerSector As Long, lpNumberOfFreeClusters As Long, lpTtoalNumberOfClusters As Long) As Long

Public Type DiskInformation
    lpSectorsPerCluster As Long
    lpBytesPerSector As Long
    lpNumberOfFreeClusters As Long
    lpTotalNumberOfClusters As Long
End Type


' ----------
' Function
' ----------

Function FreeDiskSpace()
    Dim info As DiskInformation
    Dim lAnswer As Long
    Dim lpRootPathName As String
    Dim lpSectorsPerCluster As Long
    Dim lpBytesPerSector As Long
    Dim lpNumberOfFreeClusters As Long
    Dim lpTotalNumberOfClusters As Long
    Dim lBytesPerCluster As Long
    Dim lNumFreeBytes As Double
    Dim sString As String

    lpRootPathName = "c:\"
    lAnswer = GetDiskFreeSpace(lpRootPathName, lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters)
    lBytesPerCluster = lpSectorsPerCluster * lpBytesPerSector
    lNumFreeBytes = lBytesPerCluster * lpNumberOfFreeClusters

    ' sString = "Number of Free Bytes : " & lNumFreeBytes & vbCr & vbLf
    ' sString = sString & "Number of Free Kilobytes: " & (lNumFreeBytes / 1024) & "K" & vbCr & vbLf
    ' sString = sString & "Number of Free Megabytes: " & Format(((lNumFreeBytes / 1024) / 1024), "0.00") & "MB"
End Function
