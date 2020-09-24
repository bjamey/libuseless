' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Add all Known Colors to ComboBox, ListBox Control
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Add all Known Colors to ComboBox/ListBox Control

Imports System.Drawing

Dim kColor As KnownColor

For kColor = KnownColor.AliceBlue To KnownColor.YellowGreen
    cmbColor.Items.Add(kColor)
Next
