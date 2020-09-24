// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Hide Task Bar
//
//        Hide (& Show) Task Bar
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


procedure TMainForm.TaskBar(Show: boolean);
var
  hTaskBar : THandle;
begin
  hTaskbar := FindWindow('Shell_TrayWnd', Nil);
  if Show then
    ShowWindow(hTaskBar, SW_SHOWNORMAL)
  else
    ShowWindow(hTaskBar, SW_HIDE);
end;
