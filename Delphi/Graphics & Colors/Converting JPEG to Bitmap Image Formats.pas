// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Converting JPEG to Bitmap Image Formats
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

var
   stImagem: TFileStream;
   stMemImg: TMemoryStream;
   bmpImg : TBitMap;
   grphImg : TJPEGImage;
   //img : TImage;
begin
     grphImg := TJPEGImage.Create;
     bmpImg := TBitMap.Create;
     //img := Timage.Create(self);
     stImagem := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
     stMemImg := TMemoryStream.Create;

     Try
     stImagem.Position := 0;
     if AnsiCompareStr(UpperCase(Copy(FileName, Length(FileName) - 2, 3)), UpperCase('bmp')) = 0 then
          bmpImg.LoadFromStream(stImagem)
     else
     begin
          grphImg.LoadFromStream(stImagem);
          //grphImg.LoadFromFile(FileName);
          //grphImg.Performance := jpBestSpeed;
          //grphImg.DIBNeeded;
          //grphImg.CompressionQuality := 1 {Nombre de 1 a 100};
          grphImg.SaveToStream(stImagem);
          //grphImg.DIBNeeded;
          //grphImg.Smoothing := True;
          //bmpImg.Width := grphImg.Width;
          //bmpImg.Height := grphImg.Height;
          //bmpImg.Canvas.Draw(0,0, TGraphic(grphImg));
          //bmpImg.FreeImage;
          bmpImg.Assign(grphImg);  // Here where the Exception occurs **********
          //img.Picture.Bitmap.LoadFromStream(stImagem);;
          //img.Picture.Bitmap.SaveToStream(stMemImg);
     end;

     bmpImg.SaveToStream(stMemImg);
     stMemImg.Position := 0;
     SLSIBdtstImagemOSIMAGEM.LoadFromStream(stMemImg);

     Finally
     stImagem.Free;
     stMemImg.Free;
     grphImg.Free;
     bmpImg.Free;
     End;
end;
