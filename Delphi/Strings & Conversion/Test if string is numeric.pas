// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Test if string is numeric
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Test if string is numeric
function IsNumeric(s : string): Boolean;
var
    P : PChar;
    sText : String;
begin
     if Length(s) = 0 then
     begin
          Result := False;
          Exit;
     end;

     sText := s;

     sText := StringReplace(sText, ',', '', [rfReplaceAll]);

     P := PChar(sText);
     Result := False;

     while (P^ <> #0) do
     begin
          if not (P^ in ['0'..'9']) then Exit;
          // if not ((P^ in ['0'..'9']) Or (P^ = ',')) then Exit;

          Inc(P);
     end;

     Result := True;
end;                    
