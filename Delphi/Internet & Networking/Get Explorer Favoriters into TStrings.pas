// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Get Explorer Favoriters into TStrings (i.e. TMemo.Lines)
//
// Date : 26/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


uses
  { ... , } shlobj;

Type

  { ... }
                   
  private
    function GetIEFavorites(const favpath: string):TStrings;


{ ... }


// Button click event: get favorites into Memo's TStrings

procedure TForm1.Button1Click(Sender: TObject);
var
  pidl: PItemIDList;
  FavPath: array[0..MAX_PATH] of char;
begin
  SHGetSpecialFolderLocation(Handle, CSIDL_FAVORITES, pidl);
  SHGetPathFromIDList(pidl, favpath);
  Memo1.Clear;
  Memo1.Lines := GetIEFavorites(StrPas(FavPath));
end;


// Function: Get IE Favorites

function TForm1.GetIEFavorites(const favpath: string):TStrings;
var
  searchrec: TSearchrec;
  str: TStrings;
  path, dir ,filename: String;
  Buffer: array[0..2047] of Char;
  found: Integer;
begin
  str := TStringList.Create;
  //Get all file names in the favourites path
  path := FavPath + '\*.URL';
  dir := ExtractFilepath(path);

  found := FindFirst(path, faAnyFile, searchrec);
  while found = 0 do
  begin
    //Get now URLs from files in variable files
    SetString(filename, Buffer,
              GetPrivateProfileString('InternetShortcut',
              PChar('URL'), NIL, Buffer, SizeOf(Buffer),
              PChar(dir + searchrec.Name)));
    str.Add(filename);
    found := FindNext(searchrec);
  end;

  found := FindFirst(dir + '\*.*', faAnyFile, searchrec);
  while found = 0 do
  begin
    if ((searchrec.Attr and faDirectory) > 0) and
        (searchrec.Name[1] <> '.') then
      begin
        str.Add('');
        str.Add(searchrec.name);
        str.AddStrings(GetIEFavorites(dir + '\' + searchrec.name));
      end;
    found := FindNext(searchrec);
  end;
  FindClose(searchrec);
  Result := str;
end;

