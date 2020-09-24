' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Auto Complete ComboBox VB·Net
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Private Sub cboName_Leave(ByVal sender As Object, ByVal e As System.EventArgs)
                                                            Handles cboName.Leave
    Dim recRowView As DataRowView
    Dim recName As DB.tblNameRow

    AutoCompleteCombo_Leave(cboName)

    'OPTIONAL: Now you can  do some extra handling if you want

    'Get the Selected Record from my Data Bound Combo (Return Type is DataRowView)
    recRowView = cboName.SelectedItem
    If recRowView Is Nothing Then Exit Sub

    'Display the Name Info (Row Type comes from my bound Dataset)
    recName = recRowView.Row
    lblAccountNum.Text = recName.AccountNum
    lblCompanyName.Text = recName.CompanyName

End Sub

Private Sub cboName_KeyUp(ByVal sender As Object,
              ByVal e As System.Windows.Forms.KeyEventArgs) Handles cboName.KeyUp

    AutoCompleteCombo_KeyUp(cboName, e)

End Sub

' Here are the Generic Functions for handling the events:
Public Sub AutoCompleteCombo_KeyUp(ByVal cbo As ComboBox, ByVal e As KeyEventArgs)
    Dim sTypedText As String
    Dim iFoundIndex As Integer
    Dim oFoundItem As Object
    Dim sFoundText As String
    Dim sAppendText As String

    'Allow select keys without Autocompleting
    Select Case e.KeyCode
        Case Keys.Back, Keys.Left, Keys.Right, Keys.Up, Keys.Delete, Keys.Down
            Return
    End Select

    'Get the Typed Text and Find it in the list
    sTypedText = cbo.Text
    iFoundIndex = cbo.FindString(sTypedText)

    'If we found the Typed Text in the list then Autocomplete
    If iFoundIndex >= 0 Then

        'Get the Item from the list (Return Type depends if Datasource was bound
        ' or List Created)
        oFoundItem = cbo.Items(iFoundIndex)

        'Use the ListControl.GetItemText to resolve the Name in case the Combo
        ' was Data bound
        sFoundText = cbo.GetItemText(oFoundItem)

        'Append then found text to the typed text to preserve case
        sAppendText = sFoundText.Substring(sTypedText.Length)
        cbo.Text = sTypedText & sAppendText

        'Select the Appended Text
        cbo.SelectionStart = sTypedText.Length
        cbo.SelectionLength = sAppendText.Length

    End If

End Sub


Public Sub AutoCompleteCombo_Leave(ByVal cbo As ComboBox)
    Dim iFoundIndex As Integer

    iFoundIndex = cbo.FindStringExact(cbo.Text)

    cbo.SelectedIndex = iFoundIndex

End Sub
