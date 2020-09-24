// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Extract plain text from html string
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Extract plain text from html string

function StripHTMLTags(const strHTML: string): string;
var
   P: PChar;
   InTag: Boolean;
   i, intResultLength: Integer;
begin
     P := PChar(strHTML);
     Result := '';

     InTag := False;
     repeat
           case P^ of
              '<': InTag := True;
              '>': InTag := False;
              #13, #10: ; {do nothing}
           else
               if not InTag then
               begin
                    if (P^ in [#9, #32]) and ((P+1)^ in [#10, #13, #32, #9, '<']) then
                    else
                        Result := Result + P^;
               end;
           end;

           Inc(P);
     until (P^ = #0);

     {convert system characters}
     Result := StringReplace(Result, '"', '"',  [rfReplaceAll]);
     Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
     Result := StringReplace(Result, '>',   '>',  [rfReplaceAll]);
     Result := StringReplace(Result, '<',   '<',  [rfReplaceAll]);
     Result := StringReplace(Result, '&',  '&',  [rfReplaceAll]);
     {here you may add another symbols from RFC if you need}
end;
