// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Kill running DLL
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


function KillDll(aDllName: string): Boolean;
var
  hDLL: THandle;
  aName: array[0..10] of char;
  FoundDLL: Boolean;
begin
  StrPCopy(aName, aDllName);
  FoundDLL := False;
  repeat
    hDLL := GetModuleHandle(aName);
    if hDLL = 0 then
      Break;
    FoundDLL := True;
    FreeLibrary(hDLL);
  until False;
  if FoundDLL then
    MessageDlg('Success!', mtInformation, [mbOK], 0)
  else
    MessageDlg('DLL not found!', mtInformation, [mbOK], 0);
end;
