// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Prevent a screensaver to kick in as long as your application is running
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows; 

...   

procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.Message = WM_SYSCOMMAND) and ((Msg.wParam = SC_SCREENSAVE) 
    or (Msg.wParam = SC_MONITORPOWER)) then
    Handled := true;
end;          

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnMessage := AppMessage;
end;           
