// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to add horizontal scrollbar to a ListBox control
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// How to add horizontal scrollbar to a ListBox control

procedure Add_horizontal_Scrollbar(aListBox : TListBox);
var
   i, MaxWidth : Integer;
begin
     MaxWidth := 0;

     with aListBox do
     begin
          for i := 0 to Items.Count - 1 do
          begin
               if MaxWidth < Canvas.TextWidth(Items.Strings[i]) then
                  MaxWidth := Canvas.TextWidth(Items.Strings[i]);

                  SendMessage(Handle, LB_SETHORIZONTALEXTENT, MaxWidth + 100, 0);
          end;
     end;
end;
