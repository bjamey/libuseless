' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Retreive ALL the information about Access Table & Fields using ADO
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Declarations

Option Explicit

'Properties of the Catalog
Private Catalog As ADOX.Catalog
Private Col     As ADOX.Column
Private Cols    As ADOX.Columns
Private Grp     As ADOX.Group
Private Grps    As ADOX.Groups
Private Ndx     As ADOX.Index
Private Ndxs    As ADOX.Indexes
Private Key     As ADOX.Key
Private Keys    As ADOX.Keys
Private Proc    As ADOX.Procedure
Private Procs   As ADOX.Procedures
Private Prop    As ADOX.Property
Private Props   As ADOX.Properties
Private Table   As ADOX.Table
Private Tables  As ADOX.Tables
Private User    As ADOX.User
Private Users   As ADOX.Users
Private View    As ADOX.View
Private Views   As ADOX.Views

Public Enum TblProps
    tblTempTable = 0
    tblValidationText = 1
    tblValidationRule = 2
    tblCacheLinkNamePassword = 3
    tblRemoteTableName = 4
    tblLinkProviderString = 5
    tblLinkDataSource = 6
    tblExclusiveLink = 7
    tblCreateLink = 8
    tblTableHiddenInAccess = 9
End Enum

Public Enum ColProps
    colAutoincrement = 0
    colDefault = 1
    colDescription = 2
    colNullable = 3
    colFixedLength = 4
    colSeed = 5
    colIncrement = 6
    colValidationText = 7
    colValidationRule = 8
    colIISNotLastColumn = 9
    colAutoGenerate = 10
    colOneBlobPerPage = 11
    colCompressedUnicode = 12
    colAllowZeroLength = 13
    colHyperlink = 14
End Enum


' Code

Public Function ColumnFormat(TableName As String, Column As Variant) As Variant
    'return variant because we do not
    'know the type of data that is going
    'to be returned to calling method
    On Error GoTo ErrHandler

    Set Table = Tables(TableName)
    Set Cols = Table.Columns
    Set Col = Cols(Column)

    ColumnFormat = NumberFormat(Col.Type)
ExitHere:
    Set Table = Nothing
    Set Cols = Nothing
    Set Col = Nothing
Exit Function
ErrHandler:
    ColumnFormat = ""
    Resume ExitHere
End Function

Public Function ColumnProperty(TableName As String, Column As Variant, Property As ColProps) As Variant
    'return variant because we do not
    'know the type of data that is going
    'to be returned to calling method
    On Error GoTo ErrHandler

    Set Table = Tables(TableName)
    Set Cols = Table.Columns
    Set Col = Cols(Column)

    ColumnProperty = Col.Properties(Property).Value

ExitHere:
    Set Table = Nothing
    Set Cols = Nothing
    Set Col = Nothing

    Exit Function

ErrHandler:
    ColumnProperty = ""
    Resume ExitHere
End Function

Public Function TableProperty(TableName As String, Property As TblProps) As Variant
    'return variant because we do not
    'know the type of data that is going
    'to be returned to calling method
    On Error GoTo ErrHandler

    Set Table = Tables(TableName)
    Set Props = Table.Properties
    TableProperty = Table.Properties(Property).Value

ExitHere:
    Set Table = Nothing
    Set Props = Nothing

    Exit Function

ErrHandler:
    TableProperty = Nothing
    Resume ExitHere
End Function

Private Function NumberFormat(ColType As ADODB.DataTypeEnum) As String
    Select Case ColType
        Case adEmpty                                                '  0 - No value was specified (DBTYPE_EMPTY).
        Case adSmallInt:         NumberFormat = "General Number"    '  2 - A 2-byte signed integer (DBTYPE_I2).
        Case adInteger:          NumberFormat = "General Number"    '  3 - A 4-byte signed integer (DBTYPE_I4).
        Case adSingle:           NumberFormat = "General Number"    '  4 - A single-precision floating point value (DBTYPE_R4).
        Case adDouble:           NumberFormat = "General Number"    '  5 - A double-precision floating point value (DBTYPE_R8).
        Case adCurrency:         NumberFormat = "Currency"          '  6 - A currency value (DBTYPE_CY). Currency is a fixed-point number with four digits to the right of the decimal point. It is stored in an 8-byte signed integer scaled by 10,000.
        Case adDate:             NumberFormat = "General Date"      '  7 - A Date value (DBTYPE_DATE). A date is stored as a Double, the whole part of which is the number of days since December 30, 1899, and the fractional part of which is the fraction of a day.
        Case adBSTR                                                 '  8 - A null-terminated character string (Unicode) (DBTYPE_BSTR).
        Case adIDispatch                                            '  9 - A pointer to an IDispatch interface on an OLE object (DBTYPE_IDISPATCH).
        Case adError                                                ' 10 - A 32-bit error code (DBTYPE_ERROR).
        Case adBoolean:          NumberFormat = "True/False"        ' 11 - A Boolean value (DBTYPE_BOOL).
        Case adVariant                                              ' 12 - An Automation Variant (DBTYPE_VARIANT).
        Case adIUnknown                                             ' 13 - A pointer to an IUnknown interface on an OLE object (DBTYPE_IUNKNOWN).
        Case adDecimal:          NumberFormat = "Standard"          ' 14 - An exact numeric value with a fixed precision and scale (DBTYPE_DECIMAL).
        Case adTinyInt:          NumberFormat = "General Number"    ' 16 - A 1-byte signed integer (DBTYPE_I1).
        Case adUnsignedTinyInt:  NumberFormat = "General Number"    ' 17 - A 1-byte unsigned integer (DBTYPE_UI1).
        Case adUnsignedSmallInt: NumberFormat = "General Number"    ' 18 - A 2-byte unsigned integer (DBTYPE_UI2).
        Case adUnsignedInt:      NumberFormat = "General Number"    ' 19 - A 4-byte unsigned integer (DBTYPE_UI4).
        Case adUnsignedBigInt:   NumberFormat = "General Number"    ' 21 - An 8-byte unsigned integer (DBTYPE_UI8).
        Case adBigInt:           NumberFormat = "General Number"    ' 20 - An 8-byte signed integer (DBTYPE_I8).
        Case adGUID                                                 ' 72 - A globally unique identifier (GUID) (DBTYPE_GUID).
        Case adBinary                                               '128 - A binary value (DBTYPE_BYTES).
        Case adChar                                                 '129 - A String value (DBTYPE_STR).
        Case adWChar                                                '130 - A null-terminated Unicode character string (DBTYPE_WSTR).
        Case adNumeric:          NumberFormat = "General Number"    '131 - An exact numeric value with a fixed precision and scale (DBTYPE_NUMERIC).
        Case adUserDefined                                          '132 - A user-defined variable (DBTYPE_UDT).
        Case adDBDate:           NumberFormat = "General Date"      '133 - A date value (yyyymmdd) (DBTYPE_DBDATE).
        Case adDBTime:           NumberFormat = "Long Time"         '134 - A time value (hhmmss) (DBTYPE_DBTIME).
        Case adDBTimeStamp:      NumberFormat = "General Date"      '135 - A date-time stamp (yyyymmddhhmmss plus a fraction in billionths) (DBTYPE_DBTIMESTAMP).
        Case adVarChar                                              '200 - A String value (Parameter object only).
        Case adLongVarChar                                          '201 - A long String value (Parameter object only).
        Case adVarWChar                                             '202 - A null-terminated Unicode character string (Parameter object only).
        Case adLongVarWChar                                         '203 - A long null-terminated string value (Parameter object only).
        Case adVarBinary                                            '204 - A binary value (Parameter object only).
        Case adLongVarBinary                                        '205 - A long binary value (Parameter object only).
    End Select
End Function

Private Function SetCatalog() As ADOX.Catalog
    'Retrieves the description of the field
    Cat.Tables(1).Columns(1).Properties(2).Value
    Set DBCatalog = Cat
    Set Cat = Nothing

    If Not Catalog Is Nothing Then
    End If
End Function

Private Sub Class_Initialize()
    'Create the Catlog
    Set Catalog = New ADOX.Catalog

    Catalog.ActiveConnection = cnADO

    Set Tables = Catalog.Tables
    Set Users = Catalog.Users
    Set Views = Catalog.Views
    Set Procs = Catalog.Procedures
    Set Grps = Catalog.Groups
End Sub

Private Sub Class_Terminate()
    Set Col = Nothing
    Set Cols = Nothing
    Set Grp = Nothing
    Set Grps = Nothing
    Set Ndx = Nothing
    Set Ndxs = Nothing
    Set Key = Nothing
    Set Keys = Nothing
    Set Proc = Nothing
    Set Procs = Nothing
    Set Prop = Nothing
    Set Props = Nothing
    Set Table = Nothing
    Set Tables = Nothing
    Set User = Nothing
    Set Users = Nothing
    Set View = Nothing
    Set Views = Nothing
    Set Catalog = Nothing
End Sub
