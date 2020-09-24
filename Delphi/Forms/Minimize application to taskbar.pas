// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Minimize application to taskbar
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

(*
A common error is attempting to minimize the form (WindowStyle := wsMinimized),
rather than the application itself.
*)

...

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.Minimize;
end;

