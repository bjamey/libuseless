// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Avoid Flickering in graphics programming
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

// There are four ways to reduce Flickering:
// 1. Use the DoubleBuffered property of TWinControl descendants: set
DoubleBuffered := true;

// 2. If your control is not transparent, include csOpaque in ControlStyle: 
ControlStyle := ControlStyle + [csOpaque];

// 3. Handle the WM_ERASEBKGND Windows message and set
Msg.Result := 1;
//in the handler.

//4. Use off-screen bitmaps (like double-buffering, but works for any control)
//   Let’s see an example of the last method:

uses
  Graphics;          
...    
procedure TForm1.Paint(Sender: TObject);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Width := ClientWidth;
  bmp.Height := ClientHeight;
  //now draw on bmp.Canvas as you would do on TForm1.Canvas
  with bmp.Canvas do
  begin        
    ...      
  end;
  Canvas.Draw(0, 0, bmp);
  bmp.Free;
end;
                              
