// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Using windows API in textbox programming
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------
 
 
Memo1.Perform(EM_LINEFROMCHAR, nCaret, 0)
// returns zero-based index of the line which contains zero-based caret
// poisition nCaret. If nCaret is -1 then the index of the current line is returned.

Memo1.Perform(EM_LINEINDEX, nLine, 0)
// returns caret position at the beginning of the line nLine. If nLine is -1
// then the beginning of the current line is returned.

Memo1.Perform(EM_LINELENGTH, nCaret, 0)
//returns the length of the line which contains caret position nCaret.

Memo1.Perform(EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, MAKELONG(wLeft,wRight))
// sets the left and right margin of memo to wLeft and wRight pixels, respectively.

Memo1.Perform(EM_CHARFROMPOS, 0, MAKELPARAM(x,y))
// returns character index in the low-order word and the line index in the
// high-order word corresponding to the pixel position (x,y) in memo’s client area.
