// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Monitor the changes of clipboard’s content (2)
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows, Forms, Clipbrd;   
  
type
  TForm1 = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  public
    procedure WMDrawClipboard(var Msg: TWMDrawClipBoard); message WM_DRAWCLIPBOARD;
  end; 
  
...    

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetClipboardViewer(Handle);
end; 

procedure TForm1.WMDrawClipboard(var Msg: TWMDrawClipBoard);
begin
  if Clipboard.HasFormat(CF_BITMAP) then
    Image1.Picture.Assign(Clipboard);
end;      
