' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Read and modify JPG images (self-contained class)
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ---------------------------------------------------------------------------------- '
'   clsJPEGasm.cls

'   Started on:     May, 23th 2004
'   By        :     Light Templer
'   Update lvl:     0
'   Last edit :     8/4/2004


' ---------------------------------------------------------------------------------- '
'
'   Description:
'   A selfcontained class based on my class clsJPEGparser to
'       * READ in a JPEG file
'       * Parse the segments
'       * Get a list with start and size of segments
'       * Isolate the comments
'       * Add/modify/remove comments
'       * Remove some segments on demand (Exif, Adobe (TM) PhotoShop
'         header, all application specific headers, all comments)
'       * Get some informations (like the TRUE size (width /height)
'         of the image even there is a Adobe PhotoShop (TM) preview
'         included ..., parseable without errors and so on)
'
'       * WRITE out a new JPEG file

' ---------------------------------------------------------------------------------- '
'
'   CREDITS:
'
'   Hans Reich          He sponsored this project to submit it on PSC!
'
'   Christian Tratz     Many thx to Christian Tratz for sharing his JPEG informations
'                       on www.codeproject.com in his Visual-C project 'Extracting
'                       IPTC header information from JPEG images' !
'
'   Eric Hamilton       for his JPEG structure docu from 1992.
'
'
'   "The Web"           Some more used JPEG informations I took from several web sites.
'
'   ALLAPI team         API information mostly taken from www.ALLAPI.NET
'                       Thx for their free fine app/lib  'API-Guide' and  'API-Viewer' !
' ---------------------------------------------------------------------------------- '

'   COPYRIGHT / CONTACT
'
'   All (C) by Light Templer.
'   Please send any problems/improvements to
'
'           schwepps_bitterlemon@gmx.de

' ---------------------------------------------------------------------------------- '

'   EXAMPLE:
'
'   Dim oJPEGasm as clsJPEGasm
'
'   Set oJPEGasm = new clsJPEGasm
'
'   ' Read and paser a JPEG file
'   oJPEGasm.ReadInJPEGFile("PathToYourSrcJPEGFile")
'
'   ' 1 - Write back the segments into a new JPEG file when successfully
'   ' parsed. Normaly file size doesn't change this way and you can be sure:
'   ' JPEG structure is valid for this file.
'   oJPEGasm.WriteOutJPEGFile("PathToYourDstJPEGFile")
'
'   ' 2 - Change some stuff in this JPEG.
'   oJPEGasm.RemoveExifHeader = True
'   oJPEGasm.AddComment "This is a demo comment"
'   Debug.Print oJPEGasm.FullReport         ' There are many more properties ...
'
'   '   Debug.Print oJPEGasm.xyz ...        ' (Many other, try it!)
'
'   oJPEGasm.RemovePhotoShopHeader = True   ' There are more switches ...
'
'   oJPEGasm.WriteOutJPEGfile("PathToNewJPEGFile")
'
'   Set oJPEGasm = Nothing
'
' ---------------------------------------------------------------------------------- '


Option Explicit


' *************************************
' *            CONSTANTS              *
' *************************************
Private Const MIN_SIZE_JPEG_FILE = 250                  ' Used for error checking. AFAIK a JPEG file
' cannot be smaller than this. (Checked using
' QuickView with a one pixel sized gray image,
' change if you want ;) !)

' Markers in a JPEG file for segments with "standard" structure:  Marker, Size , Data
Private Const MARKER_SOI = "FFD8"           ' Start-Of-Image
Private Const MARKER_EOI = "FFD9"           ' End-Of-Image

Private Const MARKER_APP0 = "FFE0"          ' Application marker 0 (there are APP0 to APP15 - FFE0 to FFEF)
Private Const MARKER_EXIF = "FFE1"          ' Exif header (mostly written by digital cameras, scanners, ...)

Private Const MARKER_APP2 = "FFE2"          ' Used by ???
Private Const MARKER_APP3 = "FFE3"          ' Used by ???
Private Const MARKER_APP4 = "FFE4"          ' Used by ???
Private Const MARKER_APP5 = "FFE5"          ' Used by ???
Private Const MARKER_APP6 = "FFE6"          ' Used by ???
Private Const MARKER_APP7 = "FFE7"          ' Used by ???
Private Const MARKER_APP8 = "FFE8"          ' Used by ???
Private Const MARKER_APP9 = "FFE9"          ' Used by ???
Private Const MARKER_APP10 = "FFEA"         ' Used by ???
Private Const MARKER_APP11 = "FFEB"         ' Used by ???
Private Const MARKER_APP12 = "FFEC"         ' Used by ???

Private Const MARKER_APP14 = "FFED"         ' APP14 (Adobe PhotoShop (TM) picture informations) ---  btw: Don't know
' why its called APP14; imho should be APP13 ...

Private Const MARKER_APPEE = "FFEE"         ' APP?? (Seen in JPEGs written by Adobe PhotoShop (TM))
Private Const MARKER_APP15 = "FFEF"         ' APP15

Private Const MARKER_DQT = "FFDB"           ' Quantization table
Private Const MARKER_DHT = "FFC4"           ' Huffman table
Private Const MARKER_SOF0 = "FFC0"          ' Start of frame
Private Const MARKER_SOS = "FFDA"           ' Start of scan
Private Const MARKER_DRI = "FFDD"           ' Define restart interval
Private Const MARKER_COM = "FFFE"           ' Comments


' === Type of coding (Baseline/Progressiv, ...) markers in a JPEG file.
' = Segments with "standard" structure:  Marker, Size , Data
Private Const MARKER_SOF1 = "FFC1"          ' Extended sequential DCT, Huffman
Private Const MARKER_SOF2 = "FFC2"          ' Progressive DCT, Huffman
Private Const MARKER_SOF3 = "FFC3"          ' Spatial (sequential) lossless, Huffman
Private Const MARKER_SOF5 = "FFC5"          ' Differential Sequential DCT, Huffman
Private Const MARKER_SOF6 = "FFC6"          ' Differential progressive DCT, Huffman
Private Const MARKER_SOF7 = "FFC7"          ' Differential spatial, Huffman
Private Const MARKER_SOF9 = "FFC9"          ' Extended sequential DCT, Arithmetic
Private Const MARKER_SOF10 = "FFCA"         ' Progressive DCT, Arithmetic
Private Const MARKER_SOF11 = "FFCB"         ' Spatial (sequential) lossless, Arithmetic
Private Const MARKER_SOF13 = "FFCD"         ' Differential sequential DCT, Arithmetic
Private Const MARKER_SOF14 = "FFCE"         ' Differential progressive DCT, Arithmetic
Private Const MARKER_SOF15 = "FFCF"         ' Differential spatial, Arithmetic

Private Const MARKER_JPG = "FFC8"
Private Const MARKER_DAC = "FFCC"           ' Define Arithmetic coding conditioning
Private Const MARKER_DNL = "FFDC"           ' Define number of Lines
Private Const MARKER_DHP = "FFDE"           ' Define Hierarchical progression
Private Const MARKER_EXP = "FFDF"           ' Expand reference components
Private Const MARKER_JPG0 = "FFF0"          ' Reserved for JPEG extensions
'                    ... to ...
Private Const MARKER_JPG13 = "FFFD"         ' Reserved for JPEG extensions

' = Markers in a JPEG file for segments without any further data, just the two marker bytes
Private Const MARKER_TEM = "FF01"           ' "Usually causes a decoding error, may be ignored"
Private Const MARKER_RTS0 = "FFD0"          ' RSTn are used for resync. You can find them within
Private Const MARKER_RTS1 = "FFD1"          ' a SOS segment only!
Private Const MARKER_RTS2 = "FFD2"
Private Const MARKER_RTS3 = "FFD3"
Private Const MARKER_RTS4 = "FFD4"
Private Const MARKER_RTS5 = "FFD5"
Private Const MARKER_RTS6 = "FFD6"
Private Const MARKER_RTS7 = "FFD7"



' *************************************
' *        API DEFINITIONS            *
' *************************************
Private Const FILE_ATTRIBUTE_DIRECTORY = &H10
Private Const INVALID_HANDLE_VALUE As Long = -1
Private Const MAX_PATH As Long = 260

Private Type FILETIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type

Private Type WIN32_FIND_DATA
    dwFileAttributes As Long
    ftCreationTime As FILETIME
    ftLastAccessTime As FILETIME
    ftLastWriteTime As FILETIME
    nFileSizeHigh As Long
    nFileSizeLow As Long
    dwReserved0 As Long
    dwReserved1 As Long
    cFileName As String * MAX_PATH
    cAlternate As String * 14
End Type

Private Declare Function API_FindFirstFile Lib "kernel32" Alias "FindFirstFileA" _
                                           (ByVal lpFileName As String, _
                                            lpFindFileData As WIN32_FIND_DATA) As Long

Private Declare Function API_FindClose Lib "kernel32" Alias "FindClose" _
                                       (ByVal hFindFile As Long) As Long


Private Declare Function API_CreateFile Lib "kernel32" Alias "CreateFileA" _
                                        (ByVal lpFileName As String, _
                                         ByVal dwDesiredAccess As Long, _
                                         ByVal dwShareMode As Long, _
                                         ByVal lpSecurityAttributes As Long, _
                                         ByVal dwCreationDisposition As Long, _
                                         ByVal dwFlagsAndAttributes As Long, _
                                         ByVal hTemplateFile As Long) As Long

Private Declare Function API_GetFileSize Lib "kernel32" Alias "GetFileSize" _
                                         (ByVal hFile As Long, _
                                          lpFileSizeHigh As Long) As Long

Private Declare Function API_ReadFile Lib "kernel32" Alias "ReadFile" _
                                      (ByVal hFile As Long, _
                                       lpBuffer As Any, _
                                       ByVal nNumberOfBytesToRead As Long, _
                                       lpNumberOfBytesRead As Long, _
                                       ByVal lpOverlapped As Any) As Long

Private Declare Function API_WriteFile Lib "kernel32" Alias "WriteFile" _
                                       (ByVal hFile As Long, _
                                        lpBuffer As Any, _
                                        ByVal nNumberOfBytesToWrite As Long, _
                                        lpNumberOfBytesWritten As Long, _
                                        ByVal lpOverlapped As Any) As Long

Private Declare Function API_CloseHandle Lib "kernel32" Alias "CloseHandle" _
                                         (ByVal hObject As Long) As Long




' *************************************
' *            PRIVATES               *
' *************************************

Private arrByteJPEGfile() As Byte           ' Here we hold the whole file in memory to parse it.
' Size should be no problem - JPEGs are small.

Private Type tpSegmentList                      ' List with pointers, lenght and types of the JPEGs segments.
    ' Filled on parsing the file.
    sType As String    ' Segment type, e.g. FFC4 for 'Huffman table'
    lStart As Long    ' Index into arrByteJPEGfile()
    lLength As Long    ' Size of segment in arrByteJPEGfile()
End Type


Private Type tpMvar                             ' UDT to hold all local informations in one easy to access var

    HasPreview As Boolean
    HasEXIFHeader As Boolean
    HasPhotoShopComments As Boolean
    ParsedWithoutProblems As Boolean

    SrcFilename As String
    Filesize As Long    ' Source file's size
    DstFilename As String
    JPEGVersion As String
    HowManyComments As Long
    Comments() As String    ' 1-based array with (1 to HowManyComments) elements
    FullReport As String
    Resolution As String

    XsizePreview As Long
    YsizePreview As Long
    XsizePicture As Long
    YsizePicture As Long
    ColorDepthInBit As Long
    ColorDepthAsText As String

    ErrorMsg As String

    RemoveExifHeader As Boolean
    RemovePhotoShopHeader As Boolean
    RemoveAllAppHeader As Boolean

    HowManySegments As Long
    arrSegmentList() As tpSegmentList    ' A 1-based array witch represents the structure
    ' of the JPEG file saved in arrByteJPEGfile()
End Type
Private mvar As tpMvar                          ' Holds all local informations in a handy way.
'
'
'




' *************************************
' *            INIT/TERM              *
' *************************************

Private Sub Class_Initialize()

    ' nothing yet ...

End Sub

Private Sub Class_Terminate()

    ResetAll

End Sub




' *************************************
' *         PUBLIC FUNCTIONS          *
' *************************************

Public Function ReadInJPEGfile(PathFilename As String) As Boolean
    ' Returns TRUE, when loaded and parsed successfully.

    ResetAll

    With mvar
        .SrcFilename = PathFilename

        ' CHECK:  Does file exists and is it a valid file (not a directory ...)
        If DoesFileExists(PathFilename) = False Then
            .ErrorMsg = "Not a valid file:  '" + PathFilename + "' !"

            Exit Function
        End If

        ' READ:  the whole file into our local buffer byte array  'arrByteJPEGfile()'
        If ReadFileIntoBuffer(PathFilename) = False Then

            Exit Function
        End If

        If ParseFile() = False Then
            Exit Function
        End If

    End With

    ReadInJPEGfile = True
End Function

Public Sub Clear()
    ' Clears byte array with JPEG file and any information about it!
    ResetAll
End Sub

Public Function AddComment(sNewComment As String) As Long
    ' Add a new comment to the end of the comment list.
    ' Result: > 0 :  Index of new comment in list
    '         = 0 :  Error on adding (e.g. when sNewComment was empty or string longer than 65k)

    AddComment = AddToCommentList(sNewComment)
End Function

Public Function RemoveAllComments()
    ' Clear comment list completly (read-in and own comments!)

    mvar.HowManyComments = 0
    Erase mvar.Comments()

End Function

Public Function WriteOutJPEGfile(sPathFilename As String) As Boolean
    ' Write the new JPEG file into 'sPathFilename'
    ' Result: TRUE when has been written without any errors

    With mvar
        .DstFilename = sPathFilename

        If .ParsedWithoutProblems = False Then
            .ErrorMsg = "We have not parsed an input file successfully!"

            Exit Function
        End If

        If sPathFilename = "" Then
            .ErrorMsg = "We need a valid filename to write to!"

            Exit Function
        End If

        If WriteNewFile() = False Then

            Exit Function
        End If
    End With

    WriteOutJPEGfile = True

End Function




' *************************************
' *         PRIVATE FUNCTIONS         *
' *************************************

Private Function ResetAll()

    Dim EmptyDummyType As tpMvar

    Let mvar = EmptyDummyType       ' Quick erase a type var ;)
    Erase arrByteJPEGfile()

End Function


Private Function DoesFileExists(sPathFilename As String) As Boolean

    Dim hFile As Long
    Dim WFD As WIN32_FIND_DATA


    hFile = API_FindFirstFile(sPathFilename, WFD)
    If hFile <> INVALID_HANDLE_VALUE Then
        DoesFileExists = IIf((WFD.dwFileAttributes And FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY, _
                             False, True)
    End If
    API_FindClose hFile

End Function


Private Function ReadFileIntoBuffer(sPathFilename As String) As Boolean
    ' ALL done with API calls to avoid VB errors (important e.g. in NT services ...)

    Const OPEN_EXISTING = 3
    Const FILE_SHARE_READ = &H1
    Const GENERIC_READ = &H80000000
    Const READ_ERROR = 0

    Dim hFile As Long
    Dim lBytes As Long


    On Local Error GoTo error_handler

    With mvar

        ' OPEN:   the file ...
        hFile = API_CreateFile(sPathFilename, _
                               GENERIC_READ, _
                               FILE_SHARE_READ, _
                               ByVal 0&, _
                               OPEN_EXISTING, _
                               0, 0)

        If hFile = INVALID_HANDLE_VALUE Then                ' ... leave on error! ...
            .ErrorMsg = "Error opening file '" + .DstFilename + _
                        "' to READ from in procedure 'ReadFileIntoBuffer()' at class 'clsJPEGasm'"

            Exit Function
        End If

        .Filesize = API_GetFileSize(hFile, 0)               ' and get the filesize.

        ' CHECK:  Large enough to be a valid JPEG?
        If .Filesize < MIN_SIZE_JPEG_FILE Then
            .ErrorMsg = "To small to be a valid JPEG file:  '" + sPathFilename + "' !"
            API_CloseHandle hFile

            Exit Function
        End If

        ' READ: Resize the buffer and read the whole file into it
        ReDim arrByteJPEGfile(1 To .Filesize) As Byte
        If API_ReadFile(hFile, arrByteJPEGfile(1), .Filesize, lBytes, ByVal 0&) = READ_ERROR Then
            API_CloseHandle hFile
            .ErrorMsg = "Read error on:  '" + sPathFilename + "' !"

            Exit Function
        End If

        If lBytes <> .Filesize Then
            API_CloseHandle hFile
            .ErrorMsg = "Want to read " & .Filesize & " bytes from '" + sPathFilename + "', " & _
                        "got only " & lBytes & " !"

            Exit Function
        End If

        ' CLOSE: Successfully read the whole file, now close it.
        API_CloseHandle hFile

    End With

    ReadFileIntoBuffer = True

    Exit Function


error_handler:

    mvar.ErrorMsg = "[" + Err.Description + "] in procedure 'ReadFileIntoBuffer()' at class clsJPEGasm"
    If hFile Then
        API_CloseHandle hFile
    End If

End Function


Private Function ParseFile() As Boolean
    ' MAIN LOOP:  Here all parsing of the filled buffer is done

    Dim lIndex As Long    ' Pointer into buffer array:  Current position
    Dim lTmpIndex As Long   ' Pointer into buffer array:  Current position in a segment
    Dim lPtrEnd As Long    ' Pointer into buffer array:  position of last integer value (array size -1)
    Dim sSegmentMarker As String      ' 4 chars in hex e.g. 'FFDB' is the marker for the quantization table
    Dim lSegmentSize As Long      ' Counted WITHOUT the two marker bytes!
    Dim bytChar As Byte    ' A single byte multiple used
    Dim sString As String    ' Any kind of text - multiple used

    On Local Error GoTo error_handler


    lPtrEnd = UBound(arrByteJPEGfile()) - 1

    With mvar

        AddToFullReport "Filename: " & .SrcFilename                                 ' Hint:  All adding to the report is
        AddToFullReport "Filesize: " & Format(.Filesize, "#,#") & " bytes" & vbCrLf    ' done in this function or "below" it


        ' CHECK: Is it a valid JPEG file ?   (Must start with 'FF D8' and end with 'FF D9' )
        If GetIntegerAsHex(1) <> MARKER_SOI Or GetIntegerAsHex(lPtrEnd) <> MARKER_EOI Then
            .ErrorMsg = "JPEG start (SOI-FFD8) or end markers (EOI-FFD9) not valid !"

            Exit Function
        End If
        AddToFullReport "Start-Of-Image and End-Of-Image markers are ok" & vbCrLf


        ' BIG LOOP:  Jump from segment to segment, scan type and handle (some of) them
        lIndex = 3  ' Start of first segment

        Do While lIndex < lPtrEnd - 3

            ' READ:  Header (Marker and size) of current segment
            sSegmentMarker = GetIntegerAsHex(lIndex)
            lSegmentSize = GetIntegerValue(lIndex + 2)


            ' SKIP:  Any number of FF bytes between two segments are legal. We must skip them here.
            If sSegmentMarker = "FFFF" Then
                Do While arrByteJPEGfile(lIndex + 1) = &HFF
                    lIndex = lIndex + 1
                Loop
                sSegmentMarker = GetIntegerAsHex(lIndex)
                lSegmentSize = GetIntegerValue(lIndex + 2)
            End If

            Select Case sSegmentMarker

                Case MARKER_APP0        ' Application marker

                    ' Get JPEG version
                    .JPEGVersion = arrByteJPEGfile(lIndex + 9) & "." & Right$("00" & arrByteJPEGfile(lIndex + 10), 2)

                    ' Get resolution or aspect ratio
                    bytChar = arrByteJPEGfile(lIndex + 11)
                    If bytChar = 0 Then     ' aspect ratio
                        .Resolution = "Aspect ratio width/height = " & GetIntegerValue(lIndex + 12) & " : " & _
                                      GetIntegerValue(lIndex + 14)

                    ElseIf bytChar = 1 Then
                        .Resolution = GetIntegerValue(lIndex + 12) & " x " & _
                                      GetIntegerValue(lIndex + 14) & " Dots/inch (DPI)"

                    ElseIf bytChar = 2 Then
                        .Resolution = GetIntegerValue(lIndex + 12) & " x " & _
                                      GetIntegerValue(lIndex + 14) & " Dots/cm"

                    Else
                        .Resolution = "Error resolving resolution. Opcode is " & bytChar & _
                                      "Valide opcodes are 0, 1, 2"

                    End If

                    ' Check for standard JPEG thumbnails (they are rare, but anyway... )
                    If GetIntegerValue(lIndex + 16) <> 0 Then
                        .HasPreview = True
                        .XsizePreview = arrByteJPEGfile(lIndex + 16)
                        .YsizePreview = arrByteJPEGfile(lIndex + 17)
                    End If

                    AddToFullReport MARKER_APP0 & " - Application marker (APP0)" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf & _
                                    "    JPEG version: " & .JPEGVersion & vbCrLf & _
                                    "    Resolution: " & .Resolution & vbCrLf & _
                                    IIf(.HasPreview = True, _
                                        "    Preview width: " & .XsizePreview & " pixels" & vbCrLf & _
                                        "    Preview height: " & .YsizePreview & " pixels" & vbCrLf, "")


                Case MARKER_APP2, MARKER_APP3, MARKER_APP4, MARKER_APP5, MARKER_APP6, MARKER_APP7, MARKER_APP8, _
                     MARKER_APP9, MARKER_APP10, MARKER_APP11, MARKER_APP12, MARKER_APP15

                    ' Those are applikation markers some companies use (like Adobe (TM) )

                    AddToFullReport sSegmentMarker & " - APP" & Format("&H" & Right$(sSegmentMarker, 1)) & _
                                    " segment" & FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf


                Case MARKER_APP14       ' Adobe PhotoShop (TM) picture informations

                    ' HINT 1: Parsing an PhotoShop header isn't an easy task! AFAIK there's only a C++ source for.

                    ' Hint 2: In addition to the JPEG standard thumbnails Adobe specified an own version. Beside many
                    '         picture describing comments they put a whole FULL JPEG picture into this segment.
                    '         Yes, with FFD8 at beginning and FFD9 at the end. Nested, nested, ... and preventing
                    '         "stupid searching" for markers to get picture infos. (Thats the reason I must wrote
                    '         the class ... ;)

                    .HasPhotoShopComments = True

                    AddToFullReport MARKER_APP14 & " - Adobe PhotoShop (TM) picture informations" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf


                Case MARKER_APPEE       ' not an "official" name! Creation by me ;)
                    AddToFullReport MARKER_APPEE & " - #Unknown app segment - seen in JPEGs written by Adobe PhotoShop (TM)" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf


                Case MARKER_EXIF        ' Exif header
                    .HasEXIFHeader = True

                    ' HINT: Parsing an EXIF header isn't an easy task! But there's a VB class for (ExifReader).

                    AddToFullReport MARKER_EXIF & " - Exif header" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf


                Case MARKER_DRI         ' Define restart interval (always 4 bytes length)
                    AddToFullReport MARKER_DRI & " - Restart interval marker" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & " (always 4 bytes)" & vbCrLf


                Case MARKER_COM         ' Comments
                    sString = GetStringZeroTerm(lIndex + 4)
                    AddToCommentList sString

                    AddToFullReport MARKER_COM & " - Comment header" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf & _
                                    "    Comment: '" + sString + "'" + vbCrLf


                Case MARKER_SOF0, MARKER_SOF1, MARKER_SOF2, MARKER_SOF3, _
                     MARKER_SOF5, MARKER_SOF6, MARKER_SOF7               ' Start of frame (the image "header")
                    ' mabe here we need MARKER_SOF7 to
                    ' MARKER_SOF15, too. Don' know so far!

                    ' Get pics dimensions
                    .YsizePicture = GetIntegerValue(lIndex + 5)
                    .XsizePicture = GetIntegerValue(lIndex + 7)

                    ' Get colore depth as values and text
                    .ColorDepthInBit = arrByteJPEGfile(lIndex + 9) * 8
                    If .ColorDepthInBit = 8 Then
                        .ColorDepthAsText = "Grayscale 8 Bit"

                    ElseIf .ColorDepthInBit = 24 Then
                        .ColorDepthAsText = "RGB 24 Bit"

                    ElseIf .ColorDepthInBit = 32 Then
                        .ColorDepthAsText = "CMYK 32 Bit"

                    Else
                        .ColorDepthAsText = "Unknown format with " & .ColorDepthInBit & " Bit"

                    End If

                    AddToFullReport sSegmentMarker & " - Start of frame" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf & _
                                    "  Length: " & Format(lSegmentSize, "#,#") & " Bytes" & vbCrLf & _
                                    "  Pic width: " & .XsizePicture & " pixels" & vbCrLf & _
                                    "  Pic height: " & .YsizePicture & " pixels" & vbCrLf & _
                                    "  Color depth: " & .ColorDepthAsText & vbCrLf


                Case MARKER_SOS         ' Start of scan (with the image data)
                    ' Contains header AND image data, here the two size bytes are a pointer to the
                    ' end of header only! We have to manually skip the image data to find the next
                    ' segment start ... !

                    ' HINT1:  FF 00 means FF . The following 00 is a flag for a "true" FF.
                    ' HINT2:  We have to skip the resync markers (RTS0 to RTS7), too!

                    ' Skip the header
                    lTmpIndex = lIndex + lSegmentSize

                    ' Walking byte for byte through the image data to find next marker
                    Do
                        If arrByteJPEGfile(lTmpIndex) = &HFF Then
                            bytChar = arrByteJPEGfile(lTmpIndex + 1)

                            If bytChar >= &HD0 And bytChar <= &HD7 Then
                                ' Skip the resync marker
                                lTmpIndex = lTmpIndex + 1

                            ElseIf bytChar = &H0 Then
                                ' Skip the "true" FF
                                lTmpIndex = lTmpIndex + 1

                            Else
                                ' Not a resync and not a "true" FF? We reached the end and leave the loop!
                                lSegmentSize = lTmpIndex - (lIndex + 2)

                                Exit Do
                            End If
                        End If

                        lTmpIndex = lTmpIndex + 1
                    Loop

                    AddToFullReport MARKER_SOS & " - Start of scan" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf



                Case MARKER_DQT         ' Quantization table (There can be one or more!)
                    AddToFullReport MARKER_DQT & " - Quantization table" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf



                Case MARKER_DHT         ' Huffman table (There can be one or more!)
                    AddToFullReport MARKER_DHT & " - Huffman table" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf



                Case MARKER_SOF2, MARKER_SOF3, MARKER_SOF5, MARKER_SOF6, MARKER_SOF7, MARKER_SOF9, _
                     MARKER_SOF10, MARKER_SOF11, MARKER_SOF13, MARKER_SOF14, MARKER_SOF15, _
                     MARKER_JPG, MARKER_DAC, MARKER_DNL, MARKER_DHP, MARKER_EXP, MARKER_JPG0, _
                     MARKER_JPG13    ' Usually unsupported markers in a JPEG file for segments
                    ' with "standard" structure:  Marker, Size , Data

                    AddToFullReport sSegmentMarker & " - #Usually unsupported marker#" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf


                Case Else               ' Any other not yet implemented segements
                    AddToFullReport sSegmentMarker & " - #Unknown segment type#" & _
                                    FormatPositionAndLength(lIndex, lSegmentSize) & vbCrLf


            End Select

            AddToSegmentList sSegmentMarker, lIndex, lSegmentSize + 2

            ' JUMP: To start of next segment
            lIndex = lIndex + lSegmentSize + 2
        Loop

        If GetIntegerAsHex(lIndex) = MARKER_EOI Then
            ' Yes, we have reached the end and it is the JPEG End-Of-File marker, so wen can say:
            .ParsedWithoutProblems = True
            AddToFullReport "--> File successfully parsed." & vbCrLf
        Else
            ' We leaved the parsing main loop, but we are not at the end! The End-Of-File marker is missing!
            .ParsedWithoutProblems = False
            AddToFullReport "--> File not successfully parsed! We reached the end, but parts are missing." & vbCrLf
        End If
    End With

    ParseFile = True

    Exit Function


error_handler:


    mvar.ErrorMsg = "[" + Err.Description + "] in procedure 'ParseFile()' at class 'clsJPEGasm'"

End Function


Private Function GetIntegerValue(lIndex As Long) As Long
    ' Reads from position 'lIndex' two bytes and returns them as value (HighValue * 256 + LowValue)

    GetIntegerValue = CLng(arrByteJPEGfile(lIndex)) * 256& + CLng(arrByteJPEGfile(lIndex + 1))

End Function


Private Function GetIntegerAsHex(lIndex As Long) As String
    ' Reads from position 'lIndex' two bytes and returns them as a 4-digit hex string, e.g. "FFD9"

    GetIntegerAsHex = Right$("00" & Hex$(arrByteJPEGfile(lIndex)), 2) & _
                      Right$("00" & Hex$(arrByteJPEGfile(lIndex + 1)), 2)

End Function


Private Function GetStringZeroTerm(ByRef Return_lIndex As Long) As String
    ' Reads from position 'Return_lIndex' a zero terminated string
    ' After reading Return_lIndex points to the byte AFTER the terminating zero byte!

    ' Normally speed isn't a real problem here, so I leave it in native VB, not using API RtlMoveMem().
    ' Bounding/error checking is easier this way, too.

    Dim lEndOfArr As Long

    lEndOfArr = UBound(arrByteJPEGfile())
    Do While arrByteJPEGfile(Return_lIndex) <> 0

        If Return_lIndex >= lEndOfArr Then
            mvar.ErrorMsg = "String doesn't end at file end!"       ' Maybe an event handler would be better here ...

            Exit Function
        End If

        GetStringZeroTerm = GetStringZeroTerm + Chr$(arrByteJPEGfile(Return_lIndex))

        Return_lIndex = Return_lIndex + 1
    Loop

    Return_lIndex = Return_lIndex + 1

End Function


Private Function FormatPositionAndLength(lIndex As Long, lLength As Long) As String
    ' Here we have ONE central position to style the output format of the 'fullreport' - Change to your needs!

    FormatPositionAndLength = " starts at: 0x" & Hex$(lIndex) & _
                              " / " & Format(lIndex, "#,#") & _
                              "  Seg.length: 0x" & Hex$(lLength) & _
                              " / " & Format(lLength, "#,#") & " bytes"

End Function


Private Function AddToFullReport(sText As String)
    ' Here we build a "printable" string with all informations we get during parsing the segments
    ' Reports are not very long so we don't need the improved speedup version of string adding ;)

    mvar.FullReport = mvar.FullReport + sText + vbCrLf

End Function


Private Sub AddToSegmentList(sSegType As String, lSegStart As Long, lSegLen As Long)
    ' Add type, start and length of a JPEG segment to our structure list

    With mvar
        .HowManySegments = .HowManySegments + 1
        ReDim Preserve .arrSegmentList(1 To .HowManySegments)   ' Slow... ok. But enough for 5 to 15 calls (normally)
        With .arrSegmentList(.HowManySegments)                  ' If you want to parse thousands of JPEGS this should
            .sType = sSegType                                   ' be changed to work with chunk array increments.
            .lStart = lSegStart
            .lLength = lSegLen
        End With
    End With

End Sub


Private Function AddToCommentList(sComment As String) As Long
    ' A comment in a comment segment can be up to nearly 65500 bytes.
    ' All format within this single string is up to you.
    ' To have more than one comment segment we build this array and
    ' add them on writing out the new JPEG file

    If sComment <> "" And Len(sComment) < 65534 Then        ' 256^2 -2 (for the two size bytes of the segment)
        With mvar
            .HowManyComments = .HowManyComments + 1
            ReDim Preserve .Comments(1 To .HowManyComments)
            .Comments(.HowManyComments) = sComment
            AddToCommentList = .HowManyComments
        End With
    End If

End Function


Private Function WriteNewFile() As Boolean
    ' Write a new JPEG file into 'mvar.DstFilename'
    ' Result: TRUE, when written without errors

    Const CREATE_ALWAYS = 2
    Const FILE_SHARE_READ = &H1
    Const GENERIC_WRITE = &H40000000

    Dim hFile As Long
    Dim i As Long
    Dim k As Long
    Dim flgSkip As Boolean
    Dim sText As String
    Dim lLen As Long
    Dim arrByteHeader(4) As Byte
    Dim arrByteComment() As Byte


    On Local Error GoTo error_handler

    With mvar
        ' ### Open new file to write to
        hFile = API_CreateFile(.DstFilename, GENERIC_WRITE, FILE_SHARE_READ, ByVal 0&, CREATE_ALWAYS, 0, 0)
        If hFile = INVALID_HANDLE_VALUE Then                ' ... leave on error! ...
            .ErrorMsg = "Error opening new file '" + .DstFilename + _
                        "' to WRITE in procedure 'WriteNewFile()' at class 'clsJPEGasm'"

            Exit Function
        End If

        ' ### Write out needed segments, skip disabled ones

        ' Write MARKER SOI
        If WriteBlockOfData(arrByteJPEGfile(), 1, 2, hFile) = False Then

            Exit Function
        End If

        ' Write comments (if any)
        If .HowManyComments > 0 Then

            ' Header part 1
            arrByteHeader(1) = &HFF                                         ' Comment marker
            arrByteHeader(2) = &HFE

            For i = 1 To .HowManyComments
                sText = .Comments(i) + Chr$(0)                              ' Comments must be zero terminated!
                lLen = Len(sText)
                If lLen > 1 Then                                            ' Maybe there was an empty comment segment
                    ' in original file ... we skip this!
                    ' Header part 2
                    arrByteHeader(3) = CByte((lLen + 2&) \ 255&)            ' Hi-Byte size
                    arrByteHeader(4) = CByte(lLen + 2& - ((lLen + 2&) \ 255&))   ' Lo-Byte size
                    ' Write header
                    If WriteBlockOfData(arrByteHeader(), 1, 4, hFile) = False Then

                        Exit Function
                    End If

                    ' Prepare comment text
                    ReDim arrByteComment(1 To lLen)
                    For k = 1 To lLen                                       ' Afaik JPEG definition for comments says:
                        arrByteComment(k) = Asc(Mid$(sText, k, 1))          ' US ASCII only, no special national stuff
                    Next k                                                  ' no Unicode. But it should be possible to
                    ' abuse this segment without problems ;) ...
                    ' Write comment
                    If WriteBlockOfData(arrByteComment(), 1, lLen, hFile) = False Then

                        Exit Function
                    End If
                End If
            Next i
        End If

        ' Write out segments in an expandable way
        For i = 1 To .HowManySegments

            flgSkip = False

            Select Case .arrSegmentList(i).sType

                Case MARKER_EXIF
                    If .RemoveExifHeader = True Then
                        flgSkip = True
                    End If

                Case MARKER_APP14, MARKER_APPEE
                    If .RemovePhotoShopHeader = True Then
                        flgSkip = True
                    End If

                Case MARKER_APP0, MARKER_APP2, MARKER_APP3, MARKER_APP4, MARKER_APP5, MARKER_APP6, MARKER_APP7, _
                     MARKER_APP8, MARKER_APP9, MARKER_APP10, MARKER_APP11, MARKER_APP12, MARKER_APP15

                    If .RemoveAllAppHeader = True Then  ' All but Adobe (TM) PhotoShop App marker!
                        flgSkip = True
                    End If

                Case MARKER_COM
                    flgSkip = True      ' Don't write them twice ;) - we have written them above already!

            End Select

            If flgSkip = False Then
                If WriteBlockOfData(arrByteJPEGfile(), .arrSegmentList(i).lStart, _
                                    .arrSegmentList(i).lLength, hFile) = False Then

                    Exit Function
                End If
            End If

        Next i

        ' Write MARKER EOI
        If WriteBlockOfData(arrByteJPEGfile(), UBound(arrByteJPEGfile()) - 1, 2, hFile) = False Then

            Exit Function
        End If

        ' ### ... and close it
        API_CloseHandle hFile
    End With
    WriteNewFile = True

    Exit Function


error_handler:

    mvar.ErrorMsg = "[" + Err.Description + "] in procedure 'WriteNewFile()' at class 'clsJPEGasm'"
    If hFile Then
        API_CloseHandle hFile
    End If

End Function

Private Function WriteBlockOfData(arrBytes() As Byte, lStartIndex As Long, lLength As Long, hFile As Long) As Boolean
    ' Write 'lLength' bytes
    ' from byte array 'arrBytes()'
    ' with start at 'lStartIndex'
    ' into file with handle 'hFile'.
    '
    ' RETURN    :   TRUE on success
    ' On ERROR  :   Set 'mvar.ErrorMsg' and close file!
    '
    ' HINT      :   Checking against array bounds is done with 1-based arrays in mind!


    Const WRITE_ERROR = 0

    Dim RETURN_lBytesWritten As Long
    Dim lRet As Long

    ' ### Some checks...
    If lStartIndex + lLength - 1 > UBound(arrBytes()) Or _
       lStartIndex < 1 Or _
       lLength < 1 Then

        mvar.ErrorMsg = "Wrong parameters in 'WriteBlockOfData()'! (Start= " & lStartIndex & ", Lenght= " & lLength & ")"
        API_CloseHandle hFile

        Exit Function
    End If

    If hFile = 0 Then
        mvar.ErrorMsg = "No valid file handle in 'WriteBlockOfData()'!"
        API_CloseHandle hFile

        Exit Function
    End If


    ' ### Write to file
    lRet = API_WriteFile(hFile, arrBytes(lStartIndex), lLength, RETURN_lBytesWritten, ByVal 0&)


    ' ### No problems?
    If lRet = WRITE_ERROR Then
        mvar.ErrorMsg = "API error on writing to new JPEG file - error #" & Err.LastDllError
        API_CloseHandle hFile

        Exit Function
    End If

    If RETURN_lBytesWritten <> lLength Then
        mvar.ErrorMsg = "Error on writing to new JPEG file - Diff on written bytes " & _
                        lLength & "/" & RETURN_lBytesWritten
        API_CloseHandle hFile

        Exit Function
    End If

    WriteBlockOfData = True

End Function




' *************************************
' *           PROPERTIES              *
' *************************************

Public Property Get HasPhotoShopComments() As Boolean

    HasPhotoShopComments = mvar.HasPhotoShopComments

End Property


Public Property Get HasEXIFHeader() As Boolean

    HasEXIFHeader = mvar.HasEXIFHeader

End Property


Public Property Get HasPreview() As Boolean

    ' HINT: Right now we can detect JPEG standard thumbnails (previews) only, NOT Adobe PhotoShop (TM) ones ...

    HasPreview = mvar.HasPreview

End Property


Public Property Get ParsedWithoutProblems() As Boolean

    ParsedWithoutProblems = mvar.ParsedWithoutProblems

End Property


Public Property Get SourceFilename() As String

    SourceFilename = mvar.SrcFilename

End Property


Public Property Get FileSizeSourceJPEG() As Long

    FileSizeSourceJPEG = mvar.Filesize

End Property


Public Property Get DestinationFilename() As String

    DestinationFilename = mvar.DstFilename

End Property


Public Property Get JPEGVersion() As String

    JPEGVersion = mvar.JPEGVersion

End Property


Public Property Get HowManyComments() As Long

    HowManyComments = mvar.HowManyComments

End Property


Public Property Get Comment(lIndex As Long) As String
    ' Comments are handled like an array

    With mvar
        If .HowManyComments < 1 Or lIndex < 1 Or lIndex > .HowManyComments Then

            Exit Property
        End If
        Comment = .Comments(lIndex)
    End With

End Property


Public Property Let Comment(lIndex As Long, sNewComment As String)
    ' Change an existing comment in list (to add a new one use 'AddComment()'

    Dim i As Long

    With mvar
        If .HowManyComments < 1 Or lIndex < 1 Or lIndex > .HowManyComments Then

            Exit Property
        End If
        If sNewComment <> "" Then
            .Comments(lIndex) = sNewComment
        Else
            ' Empty new comment: We have to remove this from the list and shrink the list!
            If .HowManyComments > 1 Then
                For i = lIndex To .HowManyComments - 1
                    .Comments(i) = .Comments(i + 1)
                Next i
                .HowManyComments = .HowManyComments - 1
                ReDim Preserve .Comments(1 To .HowManyComments)
            Else
                Erase .Comments()
            End If
        End If
    End With

End Property


Public Property Get Resolution() As String

    Resolution = mvar.Resolution

End Property


Public Property Get FullReport() As String

    FullReport = mvar.FullReport

End Property


Public Property Get XsizePicture() As Long

    XsizePicture = mvar.XsizePicture

End Property


Public Property Get YsizePicture() As Long

    YsizePicture = mvar.YsizePicture

End Property


Public Property Get XsizePreview() As Long

    XsizePreview = mvar.XsizePreview

End Property


Public Property Get YsizePreview() As Long

    YsizePreview = mvar.YsizePreview

End Property


Public Property Get ColorDepthInBit() As Long

    ColorDepthInBit = mvar.ColorDepthInBit

End Property


Public Property Get ColorDepthAsText() As String

    ColorDepthAsText = mvar.ColorDepthAsText

End Property


Public Property Get ErrorMsg() As String

    ErrorMsg = mvar.ErrorMsg

End Property


Public Property Let RemoveAllAppHeaders(flgRemoveAllAppHeaders As Boolean)
    ' All means: All, but Adobe (TM) PhotoShop header!

    mvar.RemoveAllAppHeader = flgRemoveAllAppHeaders

End Property

Public Property Get RemoveAllAppHeaders() As Boolean
    ' All means: All, but Adobe (TM) PhotoShop header!
    RemoveAllAppHeaders = mvar.RemoveAllAppHeader
End Property

Public Property Let RemovePhotoShopHeader(flgRemovePhotoShopHeader As Boolean)
    mvar.RemovePhotoShopHeader = flgRemovePhotoShopHeader
End Property

Public Property Get RemovePhotoShopHeader() As Boolean
    RemovePhotoShopHeader = mvar.RemovePhotoShopHeader
End Property

Public Property Let RemoveExifHeader(flgRemoveExifHeader As Boolean)
    mvar.RemoveExifHeader = flgRemoveExifHeader
End Property

Public Property Get RemoveExifHeader() As Boolean
    RemoveExifHeader = mvar.RemoveExifHeader
End Property
