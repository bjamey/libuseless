// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Drawing rotated text
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows, Graphics;  
  
...                

procedure AngleTextOut(ACanvas: TCanvas; Angle, X, Y: integer; AStr: string);
var
  LogFont: TLogFont;
  hOldFont, hNewFont: HFONT;
begin
  GetObject(ACanvas.Font.Handle, SizeOf(LogFont), Addr(LogFont));
  LogFont.lfEscapement := Angle * 10;
  LogFont.lfOrientation := Angle * 10;
  hNewFont := CreateFontIndirect(LogFont);
  hOldFont := SelectObject(ACanvas.Handle, hNewFont);
  ACanvas.TextOut(X, Y, AStr);
  hNewFont := SelectObject(ACanvas.Handle, hOldFont);
  DeleteObject(hNewFont);
end;     
