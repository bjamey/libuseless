// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Rotating a Bitmap Image
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

Unit Rotation;

Interface

Uses windows, Graphics;

Procedure RotateDraw24(Angle: Real; BackgroundColor: TColor; SrcBitmap, DstBitmap: tbitmap);

Implementation

Uses SysUtils;

Type
  BScan = Array of PByteArray;//Pointer;

Function ScanBitmap(Bit1: TBitmap) : BScan;
Var
  Y : Integer;

Begin
   SetLength(result,bit1.height);
   For Y := Bit1.Height-1 downto 0 do Result[Y] := Bit1.ScanLine[Y];
End;

Procedure RotateDraw24(Angle: Real; BackgroundColor: TColor; SrcBitmap, DstBitmap: tbitmap);
var
OnS,FrS   : BScan;
cosr,sinr : Real;
x, y      : Integer;
x2, y2    : Integer;

NewColor  : Integer;
CurColor  : Integer;
BackColor : Integer;
DstPos    : Integer;

scx, scy  : Integer; // Source
dcx, dcy  : Integer; // Destination

Begin
   Angle := Angle * pi / 180;

   scx := (SrcBitmap.Width div 2);
   scy := (SrcBitmap.Height div 2);
   dcx := (DstBitmap.Width div 2);
   dcy := (DstBitmap.Height div 2);


   // Convert the RGB value specified by BackgroundColor to BGR used by the BMP format.
   BackColor := Rgb(GetBValue(BackgroundColor), GetGValue(BackgroundColor), GetRValue(BackgroundColor));


   // if the bitmaps are not in pf32bit, this may take a
   //  little while to convert the pixel formats
   DstBitmap.pixelformat := pf24bit;
   SrcBitmap.pixelformat := pf24bit;

   OnS := ScanBitmap(DstBitmap);
   FrS := ScanBitmap(SrcBitmap);


   // get the sin and cos values in fixed format
   cosr := Cos(Angle);
   sinr := Sin(Angle);
   For x:=SrcBitmap.Width-1 downto 0 do
   Begin
      For y := SrcBitmap.Height-1 downto 0 do
      Begin
         x2 := dcx + Round(   (scx-x) * cosr - (scy-y) * sinr   );
         y2 := dcy + Round(   (scx-x) * sinr + (scy-y) * cosr   );


         // x2 and y2 are now the coordinates of the destination pixel
         IF x2 > -1 Then
         Begin
            IF x2 < DstBitmap.Width Then
            Begin
               IF y2 > -1 Then
               Begin
                  IF y2 < DstBitmap.Height Then
                  Begin
                     // If x2,y2 is actually inside the rectangle of
                     //  the destination bitmap then ...
                     Move(FrS[Y]^[x*3], NewColor, 3);
                     DstPos := x2*3;

                     Move(NewColor, OnS[y2]^[DstPos], 3);
                     IF (x2 > 0) Then
                     Begin
                        // If smoothing isn't wanted, remove the IF sentence below...
                        Move(OnS[y2]^[DstPos-3], CurColor, 3);
                        IF (CurColor = BackColor) Then Move(NewColor, OnS[y2]^[DstPos-3], 3);
                     End;
                     IF (x2 < DstBitmap.Width) Then
                     Begin
                        // If smoothing isn't wanted, remove the IF sentence below...
                        Move(OnS[y2]^[DstPos+3], CurColor, 3);
                        IF (CurColor = BackColor) Then Move(NewColor, OnS[y2]^[DstPos+3], 3);
                     End;
                  End;
               End;
            End;
         End;
      End;
   End;
End;

End.


// ------------------------- END OF UNIT -------------------------


Var
  SrcBitmap : TBitmap;
  DstBitmap : TBitmap;

Begin
   SrcBitmap := TBitmap.Create;
   SrcBitmap.LoadFromFile('Coffee Bean.bmp');

   DstBitmap := TBitmap.Create;
   DstBitmap.Width := 200;
   DstBitmap.Height := 200;
   DstBitmap.Canvas.Brush.Color := clRed;
   DstBitmap.Canvas.FillRect(  Rect(0, 0, DstBitmap.Width, DstBitmap.Height)  );

   RotateDraw24(45, DstBitmap.Canvas.Brush.Color, SrcBitmap, DstBitmap);

   Canvas.Draw(0, 0, DstBitmap);
   DstBitmap.Free;

   SrcBitmap.Free;
End;
