// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Get File Size Into Formatted String
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


function GetFileSize (const FileName: String): Integer;
var
  F: file of Byte;
begin
  AssignFile(F, FileName);
  {$I-}
  Reset(F);
  {$I+}
  if IOResult = 0 then
    Begin
      Result := System.FileSize(F);
      CloseFile(F);
    end
  else
    Result := -1;
end;


function AnalyzeFileSize (const FileName: String): String;
var
  Size: Integer;
  F: file of Byte;
begin
  AssignFile(F, FileName);
  {$I-}
  Reset(F);
  {$I+}
  if IOResult = 0 then
    Begin
      Size := System.FileSize(F);
      CloseFile(F);
      Result := ProcessSize(Size);
    end
  else
    Result := 'I/O Error';
end;


function ProcessSize (const Size: Integer): String;
begin
  Result := IntToStr(Size);
  case Length(Result) of
    1..3:   Result := IntToStr(size) + ' B';
    4..6:   Result := IntToStr(Size shr 10) + ' KB';
    7..9:   Result := IntToStr(Size shr 20) + ' MB';
    10..12: Result := IntToStr(Size shr 30) + ' GB';
  end;
end;



