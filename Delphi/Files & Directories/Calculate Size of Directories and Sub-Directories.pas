// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Calculate Size of Directories and Sub-Directories
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// ===========================================
// Return Total size of files in directory
// in bytes
// ===========================================

function DirSize(const ADirName : string;
                 ARecurseDirs : boolean = true) : integer;
const FIND_OK = 0;
var iResult : integer;

  // ====================
  // Recursive Routine
  // ====================
  procedure _RecurseDir(const ADirName : string);
  var sDirName : string;
      rDirInfo : TSearchRec;
      iFindResult : integer;
  begin
    sDirName := IncludeTrailingPathDelimiter(ADirName);
    iFindResult := FindFirst(sDirName + '*.*',faAnyFile,rDirInfo);

    while iFindResult = FIND_OK do begin
      // Ignore . and .. directories
      if (rDirInfo.Name[1] <> '.') then begin
        if (rDirInfo.Attr and faDirectory = faDirectory) and
          ARecurseDirs then
            _RecurseDir(sDirName + rDirInfo.Name) // Keep Recursing
        else
          inc(iResult,rDirInfo.Size);             // Accumulate Sizes
      end;

      iFindResult := FindNext(rDirInfo);
      if iFindResult <> FIND_OK then FindClose(rDirInfo);
    end;
  end;

// DirSize Main
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  iResult := 0;
  _RecurseDir(ADirName);
  Screen.Cursor := crDefault;

  Result := iResult;
end;
