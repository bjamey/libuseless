// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Detect when a form has been minimized, maximized or restored
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

  TForm1 = class(TForm) 
  ...          
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
  end;   
...   
procedure TForm1.WMSize(var Msg: TWMSize);
begin
  inherited; // otherwise TForm1.Resize is not fired
  if Msg.SizeType = SIZE_MAXIMIZED then
    ...
  else if Msg.SizeType = SIZE_RESTORED then
    ...
  else if Msg.SizeType = SIZE_MINIMIZED then
    ...
end;           
