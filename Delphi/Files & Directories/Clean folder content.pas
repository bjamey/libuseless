// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Clean folder content
//
// Input: Path    (string)  = Path to folder to clean
//        SubDir  (boolean) = if true: remove subdirectories
//        DelDir  (boolean) = If true: remove base folder
//
// Date : 01/11/2005
// By   : FSL
// ----------------------------------------------------------------------------


procedure CleanFolder(Path: string;  SubDir, DelDir: boolean);
var
  SearchRec: TSearchRec;
begin
  if (FindFirst(Path + '\*.*', faArchive, SearchRec) = 0) then
  repeat
    if (SearchRec.Attr <> faSysFile) then
      DeleteFile(Path + '\' + SearchRec.name);
  until (FindNext(SearchRec) <> 0);
  FindClose(SearchRec);

  if SubDir then // recursive loop
  begin
    if (FindFirst(Path + '\*.*', faDirectory, SearchRec) = 0) then
    repeat
      if ((SearchRec.Name <> '.') and (SearchRec.Name <> '..')) then
        CleanFolder (Path + '\' + SearchRec.Name, true, true);
    until (FindNext(SearchRec) <> 0);
    FindClose(SearchRec);
  end;

  if DelDir then
    RemoveDir(Path);
end;

  // Examples:

  { Delete all folder content, included subdirectories }

  CleanFolder('C:\TEMP\TEST', true, false);

  { Delete folder and all folder content (same as DelTree) }

  CleanFolder('C:\TEMP\TEST', true, true);

  { Delete all folder content, but not subdirectories }

  CleanFolder('C:\TEMP\TEST', false, false);


