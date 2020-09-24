// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Make transparent form
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows, Forms, Classes, Controls, ComCtrls;
  
type
  TForm1 = class(TForm)
    TrackBar1: TTrackBar;
    procedure TrackBar1Change(Sender: TObject);
  end;
  
...    

procedure SetTransparent(hWnd: longint; value: Byte);
// opaque: value=255; fully transparent: value=0
var
  iExStyle: Integer;
begin
  iExStyle := GetWindowLong(hWnd, GWL_EXSTYLE);
  if value < 255 then
  begin
    iExStyle := iExStyle Or WS_EX_LAYERED;
    SetWindowLong(hWnd, GWL_EXSTYLE, iExStyle);
    SetLayeredWindowAttributes(hWnd, 0, value, LWA_ALPHA);
  end
  else
  begin
    iExStyle := iExStyle xor WS_EX_LAYERED;
    SetWindowLong(hWnd, GWL_EXSTYLE, iExStyle);
  end;
end;    

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  SetTransparent(Handle, TrackBar1.Position);
end;               
