// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Changing text alignment
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

// By default, TCanvas.TextOut(X,Y,Text) puts the upper left corner of Text at (X,Y).

// First method:

uses
  Windows;
...
TForm1.Paint(Sender: TObject);
begin
  SetTextAlign(Canvas.Handle, TA_CENTER or TA_BOTTOM);
  Canvas.TextOut(100,100,’Hello World’);
  //other possibilities are:
  //TA_BASELINE, TA_BOTTOM, TA_TOP,
  //TA_LEFT, TA_RIGHT
end;

Second method:
...
TForm1.Paint(Sender: TObject);
var
  Text: string;
begin
  Text := ’Hello World’;
  with Canvas do             
  TextOut(100 - TextWidth(Text) div 2, 100 - TextHeight(Text), Text);
end;

