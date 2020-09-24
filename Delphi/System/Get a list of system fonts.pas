// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Get a list of system fonts
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  ComboBox1.Items.Assign(Screen.Fonts);
end;
