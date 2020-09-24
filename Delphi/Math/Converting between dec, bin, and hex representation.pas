// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Converting between dec, bin, and hex representation
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  StrUtils, SysUtils; 
  
function DecToBin(N: int64): string;
var
  i: integer;
  neg: boolean;
begin
  if N = 0 then
  begin
    result := ’0’;  
    exit
  end;
  SetLength(result, SizeOf(N)*8);
  neg := N < 0;
  N := Abs(N);
  i := 1;
  while N <> 0 do
  begin
    if N and 1 = 1 then
      result[i] := ’1’
    else
      result[i] := ’0’;
    N := N shr 1;
    Inc(i);
  end;

  if neg then
  begin
    result[i] := ’-’;
    Inc(i);
  end;
  Delete(result, i, length(result));
  result := ReverseString(result);                    
end;     

function DecToHex(N: int64): string;   
begin                                              
  if N < 0 then
    result := ’-’ + Format(’%0x’, [Abs(N)])
  else
    result := Format(’%0x’, [N]);         
end;                                 


