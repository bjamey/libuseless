// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Create form with rounded corners
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
var
  rgn: HRGN;
begin
  GetWindowRgn(Handle, rgn);
  DeleteObject(rgn);
  // set the radius of corners to 100px
  rgn:= CreateRoundRectRgn(0, 0, Width, Height, 100, 100);
  SetWindowRgn(Handle, rgn, TRUE);
end;     
