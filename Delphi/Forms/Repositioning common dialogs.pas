// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Repositioning common dialogs
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

//create handler for OnShow event of common dialog
procedure TForm1.OpenDialog1Show(Sender: TObject);
var
  hwnd: THandle;
  rect: TRect;
  dlgWidth, dlgHeight: integer;
begin
  hwnd := GetParent(OpenDialog1.Handle);
  GetWindowRect(hwnd, rect);
  dlgWidth := rect.Right-rect.Left;
  dlgHeight := rect.Bottom-rect.Top;
  MoveWindow(hwnd, Left+(Width-dlgWidth) div 2, Top+(Height-dlgHeight) div 2,
  dlgWidth, dlgHeight, true);
  Abort;
end;      
