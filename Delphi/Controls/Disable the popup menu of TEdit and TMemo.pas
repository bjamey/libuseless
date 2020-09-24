// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Disable the popup menu of TEdit and TMemo
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

//create a handler for OnContextPopup event of TMemo
procedure TForm1.Memo1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled:
Boolean);
begin
  Handled := true;
end;    
