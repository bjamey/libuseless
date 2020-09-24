// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Store and retrieve GIF,BMP and JPG in a RDBMS
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

procedure TFormTrabalhador.BtnChangeimageClick(Sender: TObject);
var
Exts : String;
begin
if OPD_TBR_FOTO.Execute then
   begin
     Exts := copy(AnsiUpperCase(ExtractFileExt(OPD_TBR_FOTO.FileName)),2,MaxLongInt);
     if Exts = 'JPEG'
        then Exts := 'JPG';
     Exts:=UpperCase(Exts);

     IF at(Exts,'JPG,GIF,BMP')=0 then
        Begin
           ShowMessage(‘this image type is not recognized’);
          BtnChangeimage.SetFocus;
          Exit;
        end;
        IMA_TBR_FOTO.Picture.LoadFromFile(OPD_TBR_FOTO.Filename);
        DMClient.CLDSTrabalhador.Edit;
        DMClient.CLDSTrabalhadorTBR_TIPOFOTO.AsString:=Exts;
         DMClient.CLDSTrabalhadorTBR_FOTO.LoadFromFile(OPD_TBR_FOTO.Filename);
         end;
end;


Procedure TFormTrabalhador.LeImagem;
var
MyJpegImage : TJpegImage;
MyGifImage : TGifImage;
MyBMP       : TBitMap;
MyBlobStream:TClientBlobStream;
begin

MyBlobStream := TClientBlobStream.Create(TBlobField(DMClient.CLDSTrabalhador.FieldByName('TBR_foto')),bmRead);
try
   if not(DMClient.CLDSTrabalhador.FieldByName('TBR_FOTO').IsNull) then
      begin
        if DMClient.CLDSTrabalhadorTBR_TIPOFOTO.AsString='BMP' then
          begin
            MyBMP:=TBitmap.Create;
            MyBMP.LoadFromStream(MyBlobStream);
            IMA_TBR_FOTO.Picture.Assign(MyBMP);
            MyBMP.Free;
          end
        else if DMClient.CLDSTrabalhadorTBR_TIPOFOTO.AsString='JPG' then
           begin
             MyJPegImage := TJPegImage.Create;
             MyJPegImage.LoadFromStream(MyBlobStream);
             IMA_TBR_FOTO.Picture.Assign(MyJPegImage);
             MyJPegImage.Free;
           end
        else
          begin
            MyGifImage := TGifImage.Create;
            MyGifImage.LoadFromStream(MyBlobStream);
            IMA_TBR_FOTO.Picture.Assign(MyGifImage.Bitmap);
            MyGifImage.Free;
          end;
     end
else
  IMA_TBR_FOTO.Picture.assign(Nil);
   finally
      MyBlobStream.Free;
   end;
end;
