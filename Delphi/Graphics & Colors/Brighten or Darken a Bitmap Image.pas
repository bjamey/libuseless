// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Brighten or Darken a Bitmap Image
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

procedure WhiteWash(src: TBitmap; ARect : TRect; WhiteWashValue : integer = 128);
  function GetPixel(x,y : integer) : pRGBTriple;
  var
    line : pbytearray;
  begin
    line := src.ScanLine[y];
    result := @line[x*3];
  end;
var
  x,y : integer;
begin
  src.PixelFormat:=pf24bit;

  if ARect.Top < 0 then exit;
  if ARect.left < 0 then exit;
  if ARect.bottom > src.Height then exit;
  if ARect.right > src.Width then exit;

  for y := ARect.top to ARect.bottom-1  do
    for x := ARect.left to Arect.right-1 do
    begin
      getpixel(x,y).rgbtRed := IntToByte(WhiteWashValue + getpixel(x,y).rgbtRed );
      getpixel(x,y).rgbtGreen := IntToByte(WhiteWashValue + getpixel(x,y).rgbtGreen );
      getpixel(x,y).rgbtBlue := IntToByte(WhiteWashValue + getpixel(x,y).rgbtBlue );
    end;
end;

function IntToByte(i:Integer):Byte;
begin
  if i>255 then
    Result:=255
  else if i<0   then
    Result:=0
  else
    Result:=i;
end;                                     
