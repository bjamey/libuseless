// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Shaping a Form around a Bitmap Image
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function TForm1.CreateRegion(Bmp: TBitmap): THandle;
var
  X, Y, StartX:Integer;
  Excl: THandle;
  Row: PRGBArray;
  TransparentColor: TRGBTriple;
begin
  // Change the format so we know how to compare
  // the colors
  Bmp.PixelFormat := pf24Bit;

  // Create a region of the whole bitmap
  // later we will take the transparent
  // bits away
  Result := CreateRectRGN(0, 0, Bmp.Width, Bmp.Height);

  // Loop down the bitmap
  for Y := 0 to Bmp.Height - 1 do
  begin
    // Get the current row of pixels
    Row := Bmp.Scanline[Y];

    // If its the first get the transparent
    // color, it must be the top left pixel
    if Y = 0 then
    begin
      TransparentColor := Row[0];
    end;

    // Reset StartX (-1) to indicate we have
    // not found a transparent area yet
    StartX := -1;

    // Loop across the row
    for X := 0 to Bmp.Width do
    begin

      // Check for transparency by comparing the color
      if(X <> Bmp.Width) and
        (Row[X].rgbtRed = TransparentColor.rgbtRed) and
        (Row[X].rgbtGreen = TransparentColor.rgbtGreen) and
        (Row[X].rgbtBlue = TransparentColor.rgbtBlue) then
      begin
        // We have (X <> Bmp.Width) in the clause so that
        // when we go past the end of the row we we can
        // exclude the remaining transparent area (if any)
        // If its transparent and the previous wasn't
        // remember were the transparency started
        if StartX = -1 then
        begin
          StartX := X;
        end;
      end
      else
      begin
        // Its not transparent
        if StartX > -1 then
        begin
          // If previous pixels were transparent we
          // can now exclude the from the region
          Excl := CreateRectRGN(StartX, Y, X, Y + 1);
          try
            // Remove the exclusion from our original region
            CombineRGN(Result, Result, Excl, RGN_DIFF);

            // Reset StartX so we can start searching
            // for the next transparent area
            StartX := -1;
          finally
            DeleteObject(Excl);
          end;
     end;
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    // We use a TImage to hold the bitmap so that
    // we can see how the form will look at design
    // time
    Bmp.Assign(Image1.Picture);
    FRegion := CreateRegion(Bmp);
    SetWindowRGN(Handle, FRegion, True);
  finally
    Bmp.Free;
  end;
end;
