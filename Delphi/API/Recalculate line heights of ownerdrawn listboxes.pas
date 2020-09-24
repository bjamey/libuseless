// -----------------------------------------------------------------------------
//                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
//  Title: Recalculate line heights of ownerdrawn listboxes
//
//  Date : 24/05/2007
//  By   : FSL
// -----------------------------------------------------------------------------

procedure Listbox_CalcLineHeights(AListbox:TListbox);
var
  i, h : integer;
  MeasureItemEvent : TMeasureItemEvent;

begin
     if Assigned(AListbox) and AListbox.HandleAllocated then
     begin
          with AListbox do
          begin
               MeasureItemEvent := OnMeasureItem;

               if Assigned(MeasureItemEvent) then
               begin
                    for i := 0 to Items.Count - 1 do
                    begin
                         MeasureItemEvent(AListbox, i, h);
                         SendMessage(Handle, LB_SETITEMHEIGHT, i, h);
                    end;
               end;
          end;
     end;
end;
