// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Set a form to stay on top of all other (non-topmost) windows
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

...    

uses
  Forms, Windows;
  
...           

procedure SetTopmost(AForm: TForm; ATop: boolean);
begin
  if ATop then
    SetWindowPos(AForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
  else
    SetWindowPos(AForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
  ;
end;
