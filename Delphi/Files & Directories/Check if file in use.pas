// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.1  (c)2007 FSL - FreeSoftLand
// Title: Check if File in use
//
// Date : 10/01/2007
// By   : FSL
// ----------------------------------------------------------------------------

function FileInUse(FileName: string): Boolean;
var hFileRes: HFILE;
begin
  Result := False;
  if not FileExists(FileName) then exit;
  hFileRes := CreateFile(PChar(FileName),
                                    GENERIC_READ or GENERIC_WRITE,
                                    0,
                                    nil,
                                    OPEN_EXISTING,
                                    FILE_ATTRIBUTE_NORMAL,
                                    0);
  Result := (hFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(hFileRes);
end;

