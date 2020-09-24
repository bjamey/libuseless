// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert short DOS-style path to long path
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ---------------------------------------------
   Convert short DOS-style path to long path
   --
   Required units: ShlObj, ActiveX
--------------------------------------------- *)

function short_to_long_Path(ShortPathName : String) : String;
var
  PIDL: PItemIDList;
  Desktop: IShellFolder;
  WidePathName: WideString;
  AnsiPathName: AnsiString;
begin
  Result := ShortPathName;

  if Succeeded(SHGetDesktopFolder(Desktop)) then
  begin
    WidePathName := ShortPathName;
    if Succeeded(Desktop.ParseDisplayName(0, nil, PWideChar(WidePathName), ULONG(nil^), PIDL, ULONG(nil^))) then
    begin
      try
        SetLength(AnsiPathName, MAX_PATH);
        SHGetPathFromIDList(PIDL, PChar(AnsiPathName));
        Result := PChar(AnsiPathName);
      finally
        CoTaskMemFree(PIDL);
      end;
    end;
  end;
end;              
