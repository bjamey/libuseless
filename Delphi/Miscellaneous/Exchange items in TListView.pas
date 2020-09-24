// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Exchange items in TListView
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Exchange items in TListView

procedure ExchangeItems(lv: TListView; const i, j: Integer);
var
   tempLI : TListItem;
begin
     lv.Items.BeginUpdate;
     try
        tempLI := TListItem.Create(lv.Items);
        try
           tempLI.Assign(lv.Items.Item[i]);
           lv.Items.Item[i].Assign(lv.Items.Item[j]);
           lv.Items.Item[j].Assign(tempLI);
        finally
               tempLI.Free;
        end;
     finally
            lv.Items.EndUpdate
     end;
end;
