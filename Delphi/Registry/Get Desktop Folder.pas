// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: GetDesktopFolder
//
// Date : 23/11/2005
// By   : Stefano
//
// Return desktop folder path for current user.
// ----------------------------------------------------------------------------

uses Registry;

// -------------------------------------

function GetCartellaDesktop: string;
var
  Reg: TRegistry;
  sPathCartellaDesktop: string;
begin
  Reg := TRegistry.Create;

  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion' + '\Explorer\Shell Folders', FALSE) then
      sPathCartellaDesktop := Reg.ReadString('Desktop');
  finally
    Reg.Free;
  end;

  if not DirectoryExists(sPathCartellaDesktop) then
    sPathCartellaDesktop := '';

  Result := sPathCartellaDesktop;
end;
