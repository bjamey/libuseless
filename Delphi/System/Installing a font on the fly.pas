// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Installing a font on the fly
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

// Assume that a font ?le MyFont.ttf resides in application directory. 

uses
  Windows, Forms, SysUtils;   
  
...                 

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddFontResource(PChar(ExtractFilePath(Application.ExeName) + ’\MyFont.ttf’));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;  

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RemoveFontResource(PChar(ExtractFilePath(Application.ExeName) + ’\MyFont.ttf’));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;                            
