// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Start application with Windows
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------
uses
  Registry;

{....}

procedure SetAutoStart(Enable: Boolean);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
      begin
        if Enable then
          Reg.WriteString(Application.Title, ParamStr(0))    // Enable AutoStart
        else
          Reg.DeleteValue(Application.Title);                // Disable AutoStart
      end;
  finally
    FreeAndNil(Reg);
  end;
end;                                                    
