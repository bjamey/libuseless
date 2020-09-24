// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Proceudres To Draw Graidents
//
//        These are the proceudres to draw graident
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


type
  TCustomColorArray = array[0..255] of TColor;


procedure DrawGradient (const DrawCanvas: TCanvas; const ColorCycles, Height,
  Width: Integer; const StartColor, EndColor: TColor);
var
  Rec: TRect;
  i: Integer;
  Temp: TBitmap;
  ColorArr: TCustomColorArray;
begin
  ColorArr := CalculateColorTable(StartColor, EndColor, ColorCycles);
  Temp := TBitmap.Create;
  Temp.Width := Width;
  Temp.Height := Height;
  Rec.Top := 0;
  Rec.Bottom := Height;

  with Temp do
    for I := 0 to ColorCycles do
      begin
        Rec.Left := MulDiv(I, Width, ColorCycles);
        Rec.Right := MulDiv(I + 1, Width, ColorCycles);
        Canvas.Brush.Color := ColorArr[i];
        Canvas.FillRect(Rec);
      end;

  DrawCanvas.Draw(0, 0, Temp);
  Temp.Free;
end;


procedure DrawGradientVertical (const DrawCanvas: TCanvas; const ColorCycles,
  Height, Width: Integer; const StartColor, EndColor: TColor);
var
  Rec: TRect;
  i: Integer;
  Temp: TBitmap;
  ColorArr: TCustomColorArray;
begin
  ColorArr := CalculateColorTable(StartColor, EndColor, ColorCycles);
  Temp := TBitmap.Create;

  try
    Temp.Width := Width;
    Temp.Height := Height;
    Rec.Left := 0;
    Rec.Right := Width;

    with Temp do
      for I := 0 to ColorCycles do
        begin
          Rec.Top := MulDiv(I, Height, ColorCycles);
          Rec.Bottom := MulDiv(I + 1, Height, ColorCycles);
          Canvas.Brush.Color := ColorArr[i];
          Canvas.FillRect(Rec);
        end;

    DrawCanvas.Draw(0, 0, Temp);
  finally
    Temp.Free
  end;
end;


procedure DrawGradientPartial (DrawCanvas: TCanvas; ColorCycles, Height,
  Width: Integer; StartPos: Integer; StartColor, EndColor: TColor);
var
  Rec: TRect;
  i: Integer;
  Temp: TBitmap;
  ColorArr: TCustomColorArray;
begin
  ColorArr := CalculateColorTable(StartColor, EndColor, ColorCycles);
  Temp := TBitmap.Create;
  Temp.Width := Width;
  Temp.Height := Height;
  Rec.Top := 0;
  Rec.Bottom := Height;

  with Temp do
    for I := 0 to ColorCycles do
      begin
        Rec.Left := MulDiv(I, Width, ColorCycles);
        Rec.Right := MulDiv(I + 1, Width, ColorCycles);
        Canvas.Brush.Color := ColorArr[i];
        Canvas.FillRect(Rec);
      end;

  DrawCanvas.Draw(StartPos, 0, Temp);
  Temp.Free;
end;


function CalculateColorTable (StartColor, EndColor: TColor; ColorCycles:
  Integer): TCustomColorArray;
var
  BeginRGB: array[0..2] of Byte;
  DiffRGB: array[0..2] of Integer;
  R, G, B, I: Byte;
begin
  BeginRGB[0] := GetRValue(ColorToRGB(StartColor));
  BeginRGB[1] := GetGValue(ColorToRGB(StartColor));
  BeginRGB[2] := GetBValue(ColorToRGB(StartColor));
  DiffRGB[0] := GetRValue(ColorToRGB(EndColor)) - BeginRGB[0];
  DiffRGB[1] := GetGValue(ColorToRGB(EndColor)) - BeginRGB[1];
  DiffRGB[2] := GetBValue(ColorToRGB(EndColor)) - BeginRGB[2];

  for i := 0 to 255 do
    begin
      R := BeginRGB[0] + MulDiv(I, DiffRGB[0], ColorCycles - 1);
      G := BeginRGB[1] + MulDiv(I, DiffRGB[1], ColorCycles - 1);
      B := BeginRGB[2] + MulDiv(I, DiffRGB[2], ColorCycles - 1);
      Result[i] := RGB(R, G, B);
    end;
end;

