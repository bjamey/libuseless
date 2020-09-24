// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert a color bitmap to greyscale
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ----------------------------------------------
   Convert a colour bitmap to greyscale
   --
   Note: IRatio and CRatio adjust the intensity
   and contrast.
---------------------------------------------- *)

type
 TRGB = record
   B : byte;
   G : byte;
   R : byte;
 end;

 TRGBArray = array[0..32767] of TRGB;
 PRGBArray = ^TRGBArray;

// convert a colour bitmap to greyscale
procedure GreyscaleBitmap(ABitmap : TBitmap ; IRatio, CRatio : Single);
var
   LRow : PRGBArray;
   Lx, Ly, LI, LRowBytes : integer;
   LIF : Single;
begin
     LRow := ABitmap.Scanline[0];
     LRowBytes := Integer(ABitmap.Scanline[1]) - Integer(LRow);
     for Ly := 0 to ABitmap.Height - 1 do
     begin
          for Lx := 0 to ABitmap.Width - 1 do
          begin
               LIF := 0.3 * LRow[Lx].R + 0.59 * LRow[Lx].G + 0.11 * LRow[Lx].B;
               LIF := 128 + CRatio * (LIF - 128);
               LI := Round(LIF * IRatio);
               if LI > 255 then LI := 255;
               LRow[Lx].B := LI;
               LRow[Lx].G := LI;
               LRow[Lx].R := LI;
          end;

          Inc(Integer(LRow), LRowBytes);
     end;
end;
