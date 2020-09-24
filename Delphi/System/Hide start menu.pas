// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Hide start menu
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Hide start menu
procedure HideStartMenu();
begin
  MoveWindow(FindWindowEx(FindWindow('shelltray_wnd', nil), 0, nil, 'button'), 0, 100, 10, 10);
end;     
