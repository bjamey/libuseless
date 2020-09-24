// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: PopUp Menu Management
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

private
  procedure ClickedPopUpMenu (Sender: TObject); // PopUp handler declaration


// ---------------------------------------------------------------------
// Load PopUp menu with 20 sample lines;
// Lines are appended to existing ones.
// ---------------------------------------------------------------------
procedure TMainForm.LoadPopUpMenu;
var
  i: Integer;
  MenuItem: TMenuItem;

begin
  for i := 1 to 20 do
    begin
      MenuItem := TMenuItem.Create(MainForm);        // Create new menu item
      MenuItem.Caption := IntToStr(i);               // Assign menu item caption
      MenuItem.Tag := i;                             // Assign menu item tag
      MenuItem.OnClick := MainForm.ClickedPopUpMenu; // Assign click event to menu item
      MainForm.PopUpMenu.Items.Add(MenuItem);        // Add item to menu
    end;
end;


// --------------------------------------------------------------
// Remove PopUp menu items... except for items 0 and 1 (i.e clear
// menu command and separation line).
// --------------------------------------------------------------
procedure TMainForm.ClearPopUpMenu;
var
  i: Integer;

begin
  for i := PopUpMenu.Items.Count - 1 downto 2 do
    PopUpMenu.Items.Delete(i);
end;


// ---------------------------------------------------------
// PopUp menu items click management.
// ---------------------------------------------------------
procedure TMainForm.ClickedPopUpMenu (Sender: TObject);
var
  ItemText: string;
  ItemTarget: Integer;

begin
  ItemText := (Sender as TMenuItem).Caption;
  ItemTarget := (Sender as TMenuItem).Tag;
  {
    Your routine here:
    ...
    ...
  }
end;
