// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Determine the size of a le without opening it
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  SysUtils;  
  
...        

function FileSizeByName(const AFile: string): integer;
var
  sr: TSearchRec;
begin
  if (Pos(AFile,’*’) <> 0) or (Pos(AFile,’?’) <> 0) or (FindFirst(AFile, faAnyFile,
      sr) <> 0) then  
    result := -1 //file was not found
  else
    result := sr.Size;
end;                    
