// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Capture Desktop and Save as Image
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit Unit_Form_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm_Main = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btnCaptureDesktop: TButton;
    cbHideProgramOnCapture: TCheckBox;
    cbCreateBMPFile: TCheckBox;
    procedure btnCaptureDesktopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Main: TForm_Main;

implementation

uses Unit_Form_DrawingBoard;

{$R *.DFM}

procedure TForm_Main.btnCaptureDesktopClick(Sender: TObject);
var
  hdcWindowsDesktop : HDC;     //DC handle
  hdcTempBitmap     : HDC;
  hbmTempBitmap     : HBITMAP; //Bitmap handle
  HRes, VRes        : Integer;
  MyBitmap : TBitmap;
begin
  //Terms:
  //DC = display device context
  //HDC = a handle for a display device context

  //You can use one of the following methods to get and HDC to the windows desktop

  //Create a DC of the desktop window and get its handle
  //hdcWindowsDesktop := CreateDC('DISPLAY', nil, nil, nil);
  //  or
  //Get the HDC of the desktop window
  //hdcWindowsDesktop := GetDC(GetDesktopWindow);

  //I decided to use this one
  hdcWindowsDesktop := GetDC(GetDesktopWindow);
  //Create a DC for the bitmap that will be created
  hdcTempBitmap := CreateCompatibleDC(hdcWindowsDesktop);
  if hdcTempBitmap = NULL then ShowMessage('CreateCompatibleDC Failed');
  //Get the width and hight parameters of the windows desktop
  HRes := GetDeviceCaps(hdcWindowsDesktop, HORZRES);
  VRes := GetDeviceCaps(hdcWindowsDesktop, VERTRES);
  //Create the bitmap that will hold the windows desktop image
  hbmTempBitmap := CreateCompatibleBitmap(hdcWindowsDesktop, HRes, VRes);
  if hbmTempBitmap = 0 then ShowMessage('CreateCompatibleBitmap Failed');
  //Select the bitmap into the DC created for it
  if SelectObject(hdcTempBitmap, hbmTempBitmap) = NULL then ShowMessage('SelectObject Failed');
  //Now the bitmap can be accessed using the HDC, the HDC is used for the windows GDI functions

  if cbHideProgramOnCapture.Checked then
    begin
      Form_Main.Visible := False;
      Form_DrawingBoard.Visible := False;
      //Make sure the forms have enough time to hide or they will be caputred too!
      Application.ProcessMessages;
      Sleep(1000);
    end;

  //Copy the windows desktop image to the bitmap
  if not BitBlt(hdcTempBitmap, 0, 0, VRes, HRes, hdcWindowsDesktop, 0, 0, SRCCOPY) then
    ShowMessage('BitBlt Failed');

  if cbHideProgramOnCapture.Checked then
    begin
      Form_Main.Visible := True;
      Form_DrawingBoard.Visible := True;
    end;

  //Copy the image to the form canvas for visual feedback
  if not BitBlt(Form_DrawingBoard.Canvas.Handle, 0, 0, VRes, HRes, hdcTempBitmap, 0, 0, SRCCOPY) then
    ShowMessage('BitBlt Failed');

  if (cbCreateBMPFile.Checked) then
    begin
      MyBitmap := TBitmap.Create;
      MyBitmap.Handle := hbmTempBitmap;
      MyBitmap.SaveToFile('Test.bmp');
      MyBitmap.Free;
    end;

  //Delete the bitmap
  if not DeleteObject(hbmTempBitmap) then ShowMessage('DeleteObject Failed');
  //Delete the bitmap DC
  if not DeleteDC(hdcTempBitmap) then ShowMessage('DeleteDC Failed');
  //Release the desktop DC
  if ReleaseDC(GetDesktopWindow, hdcWindowsDesktop) <> 1 then ShowMessage('ReleaseDC Failed');
end;

end.
