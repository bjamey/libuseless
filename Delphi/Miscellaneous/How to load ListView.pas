// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: How to load ListView
//
// Date : 26/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


  ListView1.Items.Clear;

  with ListView1.items.Add do
  begin
    Caption := 'First column';
    subitems.Add('Second column');
    { ... }
    subitems.Add('N... column');
  end;
