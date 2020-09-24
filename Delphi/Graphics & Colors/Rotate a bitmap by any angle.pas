// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Rotate a bitmap by any angle
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ----------------------------------------------
   Rotate a bitmap by any angle

   iRotationAxis, jRotationAxis is the center of
   rotation.

   You can speed this up a lot by creating an array
   of scanlines for the input and output bitmaps
   before calling the procedure, then replace the
   Scanline calls in the procedure with an assignment
   to the array entry.
---------------------------------------------- *)

type
 TRGBTripleArray = array[0..MaxPixelCount - 1] of TRGBTriple;
 pRGBTripleArray = ^TRGBTripleArray;

procedure RotateBitmap(const BitmapOriginal: TBitmap;
                      var BitmapOut : TBitmap;
                      const iRotationAxis, jRotationAxis: INTEGER;
                      const AngleOfRotation: DOUBLE  {radians} );
var
   cosTheta   : extended;
   i          : integer;
   iOriginal  : integer;
   iPrime     : integer;
   j          : integer;
   jOriginal  : integer;
   jPrime     : integer;
   RowOriginal: pRGBTripleArray;
   RowRotated : pRGBTRipleArray;
   sinTheta   : extended;
begin
     // Get SIN and COS in single call from math library
     sincos(AngleOfRotation, sinTheta, cosTheta);

     // Step through each row of rotated image.
     for j := BitmapOut.Height - 1 downto 0 do
     begin
          RowRotated := BitmapOut.Scanline[j];
          jPrime := j - jRotationAxis;

          for i := BitmapOut.Width-1 downto 0 do
          begin
               iPrime := i - iRotationAxis;
               iOriginal := iRotationAxis + ROUND(iPrime * CosTheta - jPrime * sinTheta);
               jOriginal := jRotationAxis + ROUND(iPrime * sinTheta + jPrime * cosTheta);

               // Make sure (iOriginal, jOriginal) is in BitmapOriginal. If not,
               // assign blue color to corner points.
               if (iOriginal >= 0) And (iOriginal <= BitmapOriginal.Width - 1) And
                  (jOriginal >= 0) And (jOriginal <= BitmapOriginal.Height - 1)
               then
               begin
                    // Assign pixel from rotated space to current pixel in BitmapRotated
                    RowOriginal := BitmapOriginal.Scanline[jOriginal];
                    RowRotated[i] := RowOriginal[iOriginal];
               end
               else
               begin
                    RowRotated[i].rgbtBlue := 0; // assign "corner" color
                    RowRotated[i].rgbtGreen := 0;
                    RowRotated[i].rgbtRed := 0;
               end;
          end;
     end;
end;
