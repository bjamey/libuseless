// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Save graphics to a bitmap le or a Windows Metale
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Graphics; 
  
...       

procedure SaveToBitmapFile(AFile: TFilename);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Width := 400;
  bmp.Height := 400;
  with bmp.Canvas do
  begin
    //drawing commands
  end;
  bmp.SaveToFile(AFile);
  bmp.Free;
end;

procedure SaveToMetafile(AFile: TFilename);
var
  emf: TMetafile;
  mfc: TMetafileCanvas;
begin
  emf := TMetafile.Create;
  emf.Enhanced := true; // save as Enhanced Metafile
  emf.Width := 400;                                             
  emf.Height := 400;
  mfc := TMetafileCanvas.Create(emf, 0);
  with mfc do
  begin
    //drawing commands
  end;
  mfc.Free;
  emf.SaveToFile(AFile);
  emf.Free;
end;
