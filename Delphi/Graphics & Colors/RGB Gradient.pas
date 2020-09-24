// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: RGB Gradient
//
//        Create RGB Gradient into TImage object.
//
// Input: TImage container.
//
// Date :
// By   : Stefano
// ----------------------------------------------------------------------------


type
  Fase_Types = (INC_RED, INC_GREEN, INC_BLUE, DEC_RED, DEC_GREEN, DEC_BLUE);

procedure CreateRGBGradient(MyImage: TImage);
var
  step, r, g, b: Double;
  valR, valG, valB: Integer;
  fr0toR, fr0toG, fr0toB,
  frRtoFF, frGtoFF, frBtoFF: Double;
  n1, n2: Integer;
  Fase: Fase_Types;                              

begin

  { Create RGB color palette }

  MyImage.Canvas.Pen.Width := 1;
  r := $ff;
  g := 0;
  b := 0;
  valR := 0;
  valG := 0;
  valB := 0;
  step := $FF*6/MyImage.Width;

  fr0toR := r/(MyImage.Height/2);
  fr0toG := g/(MyImage.Height/2);
  fr0toB := b/(MyImage.Height/2);
  frRtoFF := ($ff-r)/(MyImage.Height/2);
  frGtoFF := ($ff-g)/(MyImage.Height/2);
  frBtoFF := ($ff-b)/(MyImage.Height/2);

  Fase := INC_GREEN;

  for n1 := 0 to MyImage.Width-1 do
    begin
      for n2 := 0 to round(MyImage.Height/2) do
        begin
          valR := round(fr0toR*n2);
          valG := round(fr0toG*n2);
          valB := round(fr0toB*n2);
          MyImage.Canvas.Pixels[n1-1,n2] := RGB(valR, valG, valB);
        end;

      for n2 := round(MyImage.Height/2)+1 to MyImage.Height do
        begin
          valR := round(frRtoFF*(n2-(MyImage.Height/2))+r);
          valG := round(frGtoFF*(n2-(MyImage.Height/2))+g);
          valB := round(frBtoFF*(n2-(MyImage.Height/2))+b);
          MyImage.Canvas.Pixels[n1-1,n2] := RGB(valR, valG, valB);
        end;

      case Fase of

        INC_GREEN:

          begin
            g := g + step;
            if g >= $FF then
              begin
                g := $FF;
                Fase := DEC_RED;
              end;
          end;

        DEC_RED:

          begin
            r := r - step;
            if r <= 0 then
              begin
                r := 0;
                Fase := INC_BLUE;
              end;
          end;

        INC_BLUE:

          begin
            b := b + step;
            if b >= $FF then
              begin
                b := $FF;
                Fase := DEC_GREEN;
              end;
          end;

        DEC_GREEN:

          begin
            g := g - step;
            if g <= 0 then
              begin
                g := 0;
                Fase := INC_RED;
              end;
          end;

        INC_RED:

          begin
            r := r + step;
            if r >= $FF then
              begin
                r := $FF;
                Fase := DEC_BLUE;
              end;
          end;

        DEC_BLUE:

          begin
            b := b - step;
            if b <= 0 then
              begin
                b := 0;
                Fase := INC_RED;
              end;
          end;

      end;

      fr0toR := r/(MyImage.Height/2);
      fr0toG := g/(MyImage.Height/2);
      fr0toB := b/(MyImage.Height/2);
      frRtoFF := ($ff-r)/(MyImage.Height/2);
      frGtoFF := ($ff-g)/(MyImage.Height/2);
      frBtoFF := ($ff-b)/(MyImage.Height/2);

    end;

end;
