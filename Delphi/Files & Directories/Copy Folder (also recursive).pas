// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Copy Folder (also recursive)
//
// Date : 14/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Perform Folder copy (also recursive if SubDir = true);
// ----------------------------------------------------------------------------

function CopyFolder(FromDir,ToDir: string; SubDir: boolean): boolean;
var                   
  SearchRec: TSearchRec;
begin
  // normalize path names trailer
  if copy(FromDir, Length(FromDir), 1) <> '\' then  FromDir := FromDir + '\';
  if copy(ToDir,   Length(ToDir),   1) <> '\' then  ToDir   := ToDir   + '\';

  // Error if source don't exist
  if not directoryExists(Copy(FromDir, 1, Length(FromDir)-1)) then
  begin
    Result := false;
    exit;
  end;

  // Create destination directory if not exists
  if not directoryExists(Copy(ToDir, 1, Length(ToDir)-1)) then
    ForceDirectories(Copy(ToDir, 1, Length(ToDir)-1));

  // FindFirst and FindNext returns 0 if file found.
  if (FindFirst(FromDir + '*.*', faArchive, SearchRec) = 0) then
  repeat
    //If not system file
    if (SearchRec.Attr <> faSysFile) then
      CopyFile(PAnsiChar(FromDir + SearchRec.Name), PAnsiChar(ToDir + SearchRec.Name), false);
  until (FindNext(SearchRec) <> 0);
  FindClose(SearchRec);

  if SubDir then // recursive loop
  begin
    // Search for subdirectory... and create if exist
    if (FindFirst(FromDir + '*.*', faDirectory, SearchRec) = 0) then
    repeat
      if ((SearchRec.Name <> '.') and (SearchRec.Name <> '..')) then
        if (SearchRec.Attr and faDirectory) = faDirectory then
          // Copy files (recurse into)
          CopyFolder(FromDir + SearchRec.Name, ToDir + SearchRec.Name, true);
    until (FindNext(SearchRec) <> 0);

    FindClose(SearchRec);
  end;
  Result := true;
end;

