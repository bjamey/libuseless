// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: ShowWithoutFlickers
//
// Tricks to show (crete) new form, without flickers.
//
// Date : 28/10/2005
// By   : Stefano
// ----------------------------------------------------------------------------


// NewForm.pas

procedure TNuovaForm.FormCreate(Sender. TObject);
begin
  AlphaBlend := true;
  AlphaBlendValue := 0;
  // (...)
end;


// ...

// MyProgram.pas

procedure TForm1.Button1Click(Sender: TObject);
var
    NewForm: TNewForm;
begin
    NewForm := TNewForm.Create(Application);
    // ...
    // put settings for new form here ...
    // ...
    NewForm.Refresh;
    NewForm.Visible := true;
    NewForm.AlphaBlendValue := 255;
end;

