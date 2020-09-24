' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Use MS Word's Spell Checker in Visual Basic
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------
' Function
' ----------

Public Function SpellCheck(ByVal IncorrectText$) As String
       Dim Word As Object, retText$

       On Error Resume Next

       ' Create the Object and open Word
       Set Word = CreateObject("Word.Basic")

       ' Change the active window to Word,
       'and insert the text from Text1 into Word.
       Word.AppShow
       Word.FileNew

       Word.Insert IncorrectText

       ' Runs the Speller Corrector
       Word.ToolsSpelling
       Word.EditSelectAll

       ' Trim the trailing character from the returned text.
       retText = Word.Selection$()
       SpellCheck = Left$(retText, Len(retText) - 1)

       ' Close the Document and return to Visual Basic.
       Word.FileClose 2
       Show

       ' Set the word object to nothing to liberate the'occupied memory
       Set Word = Nothing
End Function
