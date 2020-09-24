// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Retrive the path of the Windows directory
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows, StrUtils;
...
function GetWinDir: string;
var
  buffer: array[0..MAX_PATH] of char;;
begin
  GetWindowsDirectory(buffer, MAX_PATH);
  result := string(buffer);
  if RightStr(result,1) <> ’\’ then
    result := result + ’\’;
end;              

