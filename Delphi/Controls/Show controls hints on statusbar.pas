// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Show controls’ hints on statusbar
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

// First method: 

Button1.ShowHint := true;
StatusBar1.AutoHint := true;


// Second method:

type                                     
  TForm1 = class(TForm)
  ...
private
  procedure ShowHint(Sender: TObject);

  ...

procedure TForm1.ShowHint(Sender: TObject);
begin
  StatusBar1.SimpleText := Application.Hint;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowHint;
end;
