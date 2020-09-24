// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Using WinHelp API
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows;
  
...        

procedure TForm1.btnHelpClick(Sender: TObject);
begin
  PostMessage(Handle, WM_SYSCOMMAND, SC_CONTEXTHELP, 0);
end;
