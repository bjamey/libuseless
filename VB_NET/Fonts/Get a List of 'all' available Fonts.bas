' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Get a List of 'all' available Fonts
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' This will get all of the available fonts on the computer and add
' them to the 'cmbFont' combobox control.

Dim f As System.Drawing.Text.InstalledFontCollection = New _
    System.Drawing.Text.InstalledFontCollection

Dim fFamily As FontFamily

For Each fFamily In f.Families
    lst.Items.Add(fFamily.Name)
Next
