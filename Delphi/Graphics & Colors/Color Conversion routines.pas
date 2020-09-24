// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Color Conversion routines
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

procedure BreakColorUpIntoRGB(cColor : TColor; var r, g, b : byte);
begin
     g := GetGValue(cColor);
     b := GetBValue(cColor);
     r := GetRValue(cColor);
end;

Function BuildColorFromRGB(r,g,b:word):TColor;
begin
     if r > $FF then r := $FF;
     if g > $FF then g := $FF;
     if b > $FF then b := $FF;

     Result := RGB(r, g, b);
end;

Function TotalBlend(Color1,Color2:TColor):TColor;
var
   r, g, b : byte;
   rtot, gtot, btot : word; // Very important to use word here!!
begin
     BreakColorUpIntoRGB(Color1,r,g,b);
     rtot := r;
     gtot := g;
     btot := b;
     BreakColorUpIntoRGB(Color2, r, g, b);
     rtot := rtot + r;
     gtot := gtot + g;
     btot := btot + b;
     Result := BuildColorFromRGB(rtot, gtot, btot);
end;

Function AvgBlend(Color1,Color2:TColor):TColor;
var
   r, g, b : byte;
     rtot, gtot, btot : word;
begin
     BreakColorUpIntoRGB(Color1, r, g, b);
     rtot := r;
     gtot := g;
     btot := b;
     BreakColorUpIntoRGB(Color2, r, g, b);
     rtot := rtot + r div 2;
     gtot := gtot + g div 2;
     btot := btot + b div 2;
     Result := BuildColorFromRGB(rtot, gtot, btot);
end;

Function PseudoAlphaBlend(Color1,Color2:TColor):TColor;
 var r,g,b : byte;
     ra,ga,ba : word; //Very important to use word here!!
     iTot : word;     // Total Intensity
     iEq  : integer;  // Intensity Equalizer
begin
    BreakColorUpIntoRGB(Color1,r,g,b);
    ra:=r;
    ga:=g;
    ba:=b;
    iTot:=Round((r+g+b)*1.5); // 1.5 is a suggestion, play with it.
    BreakColorUpIntoRGB(Color2,r,g,b);
    ra:=ra+r;
    ga:=ga+g;
    ba:=ba+b;
    iEq:=((ra+ga+ba)-iTot) div 3;
    if iEq<0 then iEq:=0; // For safety reasons
    if ra>iEq then ra:=ra-iEq else ra:=0;
    if ga>iEq then ga:=ga-iEq else ga:=0;
    if ba>iEq then ba:=ba-iEq else ba:=0;

    Result := BuildColorFromRGB(ra, ga, ba);
end;

Function AlphaBlend(Color1,Color2:TColor; Alpha:byte):TColor;
var
   r,g,b : byte;
   ra,ga,ba : byte;
   rPrimary : real; // Primary (Color1) Intensity
   rSecondary: real;// Secondary (Color2) Intensity
begin
     rPrimary:=((Alpha+1)/$100);
     rSecondary:=(($100-Alpha)/$100);
     BreakColorUpIntoRGB(Color1,r,g,b);
     ra:=Trunc(r*rPrimary);
     ga:=Trunc(g*rPrimary);
     ba:=Trunc(b*rPrimary);
     BreakColorUpIntoRGB(Color2,r,g,b);
     ra:=ra+Trunc(r*rSecondary);
     ga:=ga+Trunc(g*rSecondary);
     ba:=ba+Trunc(b*rSecondary);
     Result:=BuildColorFromRGB(ra,ga,ba);
end;

//Additional:

function LightenBy(AColor: TColor; Pcnt: byte): TColor;
// adjusts AColor toward white
// Pcnt should be between 0..100;
var
   Alpha: byte;
begin
     Alpha := round((1 - (Pcnt/100)) * 255);
     Result := AlphaBlend(AColor, clWhite, Alpha);
end;

function DarkenBy(AColor: TColor; Pcnt: byte): TColor;
 // shifts AColor toward black
 // Pcnt should be between 0..100;
var
   Alpha : byte;
begin
     Alpha := round((1-(Pcnt/100)) * 255);
     Result := AlphaBlend(AColor, clBlack, Alpha);
end;
