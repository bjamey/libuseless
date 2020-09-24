// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Set control width same as printer page width
//
// Date : 14/10/2005
// By   : Stefano
//
// Set the given control width (control) same as printer paper text area width.
//
// Inputs:
//     iWantedMargin: margin (mm)
//     control:       generic TControl
//
// Outputs:
//     ...
//
// Return Value:                                                
//     print margin pixels
// ----------------------------------------------------------------------------

uses
    Printers, Windows, Forms;

// (...)

function SetSameAsPaperWidth(iWantedMargin: Integer; control: TControl): Integer;
var
  iPageWidthWithoutMargin,
  iPageWidthWithMargin,
  iMargin: Integer;
begin
  if Printer.Printers.Count > 0 then
    begin
      iPageWidthWithMargin := Round(GetDeviceCaps(Printer.Handle,
                              PHYSICALWIDTH) / GetDeviceCaps(Printer.Handle,
                              LOGPIXELSX) * Screen.PixelsPerInch);
      iMargin := Round(((iWantedMargin / 10) / 2.54) * Screen.PixelsPerInch);
      iPageWidthWithoutMargin := iPageWidthWithMargin - (iMargin * 2);
      control.Width := iPageWidthWithoutMargin;
      Result := iMargin;
    end
  else
    begin
      Result := -1;
    end;
end;

//-----------------------------------------------------------------------------
// Example:
//
// - set Memo1 (TMemo) width same as printing area
// - set Shape1 (TShape) width same as paper width
//-----------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
var
  margin: Integer;
begin
  // set margin: 1 cm (10 mm)
  // set Memo1 width
  margin := SetSameAsPaperWidth(10, TControl(Memo1));
  // set Shape1 with paper width
  Shape1.Width := Memo1.Width + (2 * margin);
  Shape1.Left := Memo1.Left - margin;     
end;

