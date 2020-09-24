' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Accept numeric values only in a textbox
' 
'  Date : 15/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'**************************************
' Name: Accept numeric values only in a textbox
' Description:It validates the entries of a textbox while it is being entered, and allows only one instance of the decimal point(period) to be entered.
' By: Tristan B. Astillero
'
'
' Inputs:It has 2 parameters: e.keychar(eventargs) and the textbox control.
'
' Returns:Returns a boolean value indicating if the event is handled or not.
'
'Assumes:If you have any suggestions or encounter an error I would appreciate your comments. Thanks. I it's simple but hopefully this will garner me some votes. =P
'
'Side Effects:None
'**************************************

Private Sub TextBox1_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles TextBox1.KeyPress
        e.Handled = NumbersOnly(e.KeyChar, TextBox1)
End Sub

Private Function NumbersOnly(ByVal pstrChar As Char, ByVal oTextBox As TextBox) As Boolean
'validate the entry for a textbox limiti
'     ng it to only numeric values and the dec
'     imal point

      'accept only one instance of the decimal point
      If (Convert.ToString(pstrChar) = "." And InStr(oTextBox.Text, ".")) Then Return True

      If Convert.ToString(pstrChar) <> "." And pstrChar <> vbBack Then
         Return IIf(IsNumeric(pstrChar), False, True) ' check if numeric is returned
      End If

      Return False 'for backspace
End Function      
