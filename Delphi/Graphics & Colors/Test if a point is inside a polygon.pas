// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Test if a point is inside a polygon
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// test if a point is inside a polygon

function PointInPoly(APoint : TPoint ; APoly : array of TPoint) : boolean;
var
   i, j : integer;
   npol : integer;
begin
     Result := false;
     npol := length(APoly);
     for i := 0 to npol - 1 do
     begin
          j := (i + 1) mod npol;
          if ((((APoly[i].Y <= APoint.Y) and (APoint.Y < APoly[j].Y)) or
               ((APoly[j].Y <= APoint.Y) and (APoint.Y < APoly[i].Y))) and
              (APoint.X < (APoly[j].X - APoly[i].X) * (APoint.Y - APoly[i].Y) /
                          (APoly[j].Y - APoly[i].Y) + APoly[i].X))
          then
              Result := not Result;
     end;
end;
