 // ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Modify the controls in common dialogs
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

...

uses
  Windows, Forms, Dialogs, Dlgs;
  
...           

//create handler for OnShow event of common dialog
procedure TForm1.OpenDialog1Show(Sender: TObject) ;
var
  hwnd: THandle;
begin
  hwnd := GetParent(OpenDialog1.Handle);
  //change title of OK button, "Open" --> "Do Open"
  SetDlgItemText(hwnd, IDOK, PChar(’&Do Open’));
  //hide the "Open as read-only" check box
  ShowWindow(GetDlgItem(hwnd,chx1),SW_HIDE);
  //these are the IDs of remaining controls:
  //IDCANCEL: the CANCEL button
  //stc3, stc2: the two label controls, "File name" and "Files of type"
  //edt1, cmb1: the edit control and combo box next to the labels
  //cmb2: combo box that allows to select the drive or folder
  //stc4: label for the cmb2 combo
  //lst1: list box that displays the contents of selected drive or folder
end;
