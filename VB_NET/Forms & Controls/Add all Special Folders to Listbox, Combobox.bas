' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Add all Special Folders to Listbox, Combobox
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' Add all special folders to a listbox or combobox

Dim sFolder As Environment.SpecialFolder

For sFolder = 0 To 43
    If Not Char.IsNumber(sFolder.ToString) Then
       lst.Items.Add(sFolder.ToString)
    End If
Next
