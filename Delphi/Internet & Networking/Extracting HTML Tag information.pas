// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Extracting HTML Tag information
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function ExtractHtmlTagValues(const HtmlText: string; TagName, AttribName: string; var Values: TStrings): integer;

function FindFirstCharAfterSpace(const Line: string; StartPos: integer): Integer;
var i: integer;
begin
  Result := -1;
  for i := StartPos to Length(Line) do
  begin
    if (Line[i] <> ' ') then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function FindFirstSpaceAfterChars(const Line: string; StartPos: integer): Integer;
begin
  Result := PosEx(' ', Line, StartPos);
end;

function FindFirstSpaceBeforeChars(const Line: string; StartPos: integer): Integer;
var i: integer;
begin
  Result := 1;
  for i := StartPos downto 1 do
  begin
    if (Line[i] = ' ') then
    begin
      Result := i;
      exit;
    end;
  end;
end;

var InnerTag: string;
    LastPos, LastInnerPos: Integer;
    SPos, LPos, RPos: Integer;
    AttribValue: string;
    ClosingChar: char;
    TempAttribName: string;
begin
  Result := 0;
  LastPos := 1;
  while (true) do
  begin
    // find outer tags '<' & '>'
    LPos := PosEx('<', HtmlText, LastPos);
    if (LPos <= 0) then break;
    RPos := PosEx('>', HtmlText, LPos+1);
    if (RPos <= 0) then
      LastPos := LPos + 1
    else
      LastPos := RPos + 1;

    // get inner tag
    InnerTag := Copy(HtmlText, LPos+1, RPos-LPos-1);
    InnerTag := Trim(InnerTag); // remove spaces
    if (Length(InnerTag) < Length(TagName)) then continue;

    // check tag name
    if (SameText(Copy(InnerTag, 1, Length(TagName)), TagName)) then
    begin
      // found tag
      AttribValue := '';
      LastInnerPos := Length(TagName)+1;
      while (LastInnerPos < Length(InnerTag)) do
      begin
        // find first '=' after LastInnerPos
        RPos := PosEx('=', InnerTag, LastInnerPos);
        if (RPos <= 0) then break;

        // this way you can check for multiple attrib names and not a specific attrib
        SPos := FindFirstSpaceBeforeChars(InnerTag, RPos);
        TempAttribName := Trim(Copy(InnerTag, SPos, RPos-SPos));
        if (true) then
        begin
          // found correct tag
          LPos := FindFirstCharAfterSpace(InnerTag, RPos+1);
          if (LPos <= 0) then
          begin
            LastInnerPos := RPos + 1;
            continue;
          end;
          LPos := FindFirstCharAfterSpace(InnerTag, LPos); // get to first char after '='
          if (LPos <= 0) then continue;
          if ((InnerTag[LPos] <> '"') and (InnerTag[LPos] <> '''')) then
          begin
            // AttribValue is not between '"' or ''' so get it
            RPos := FindFirstSpaceAfterChars(InnerTag, LPos+1);
            if (RPos <= 0) then
              AttribValue := Copy(InnerTag, LPos, Length(InnerTag)-LPos+1)
            else
              AttribValue := Copy(InnerTag, LPos, RPos-LPos+1);
          end
          else
          begin
            // get url between '"' or '''
            ClosingChar := InnerTag[LPos];
            RPos := PosEx(ClosingChar, InnerTag, LPos+1);
            if (RPos <= 0) then
              AttribValue := Copy(InnerTag, LPos+1, Length(InnerTag)-LPos-1)
            else
              AttribValue := Copy(InnerTag, LPos+1, RPos-LPos-1)
          end;

          if (SameText(TempAttribName, AttribName)) and (AttribValue <> '') then
          begin
            Values.Add(AttribValue);
            inc(Result);
          end;
        end;

        if (RPos <= 0) then
          LastInnerPos := Length(InnerTag)
        else
          LastInnerPos := RPos+1;
      end;
    end;
  end;
end;
