// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Send a le to Recycle bin
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ShellApi.pas; 
               
...            

function RecycleFile(const AFile: string): boolean;
var
  foStruct: TSHFileOpStruct;
begin
  with foStruct do
  begin
    wnd := 0;
    wFunc := FO_DELETE;
    pFrom := PChar(AFile+#0#0);
    pTo := nil;
    fFlags:= FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := SHFileOperation(foStruct) = 0;
end;               
