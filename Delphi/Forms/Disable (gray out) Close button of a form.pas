// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Disable (gray out) Close button of a form
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
var
  hSysMenu: HMENU;
begin
  hSysMenu := GetSystemMenu(Handle, false);
  EnableMenuItem(hSysMenu, SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
end;   
