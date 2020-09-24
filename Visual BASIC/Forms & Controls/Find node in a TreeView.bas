' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Find node in a TreeView
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------
' Code
' ----------

Private Sub FindNode(NodeText As String)
    Dim TreeNode As Node

    For Each TreeNode In TreeView.Nodes
        If TreeNode.Text = NodeText Then
            lNod = TreeNode
            TreeNode.Selected = True
            TreeView.SetFocus

            Exit Sub
        End If
    Next
End Sub
