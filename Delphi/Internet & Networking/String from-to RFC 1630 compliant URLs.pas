// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: String from-to RFC 1630 compliant URLs
//
//        URLEncode - Convert string into a RFC 1630 compliant URL
//        URLDecode - Convert RFC 1630 compliant URL into string
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

const
  ValidURLChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_@.&+-!*"''(),;/#?:';

{....}

  function URLEncode(Value: string): string; // Converts string To A URLEncoded string
  function URLDecode(Value: string): string; // Converts string From A URLEncoded string

{....}

// -----------------------------------------------------------------------------
// Convert string into a RFC 1630 compliant URL
// -----------------------------------------------------------------------------
function URLEncode(Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if Pos(UpperCase(Value[I]), ValidURLChars) > 0 then
      Result := Result + Value[I]
    else
    begin
      if Value[I] = ' ' then
        Result := Result + '+'
      else
      begin
        Result := Result + '%';
        Result := Result + IntToHex(Byte(Value[I]), 2);
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Convert RFC 1630 compliant URL into string
// -----------------------------------------------------------------------------
function URLDecode(Value: string): string;
const
  HexChars = '0123456789ABCDEF';
var
  I: Integer;
  Ch, H1, H2: Char;
begin
  Result := '';
  I := 1;
  while I <= Length(Value) do
  begin
    Ch := Value[I];
    case Ch of
      '%':
        begin
          H1 := Value[I + 1];
          H2 := Value[I + 2];
          Inc(I, 2);
          Result := Result + Chr(((Pos(H1, HexChars) - 1) * 16) + (Pos(H2, HexChars) - 1));
        end;
      '+': Result := Result + ' ';
      '&': Result := Result + #13 + #10;
    else
      Result := Result + Ch;
    end;
    Inc(I);                          
  end;
end;
