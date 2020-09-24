// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Remove an entry from a Run registry key
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

procedure RemoveFromRunKey(AppTitle : string);
var
   i : integer;
   sKey : string;
   Reg : TRegistry;
   ListOfEntries : TStringList;
begin
     Reg := TRegistry.Create;
     try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        sKey := 'Software\Microsoft\Windows\CurrentVersion\Run';

        // Check if key exist...
        // ...if yes, try to delete the entry for ApTitle

        if Not Reg.OpenKey(sKey, False) then
           ShowMessage('Key not found')
        else
        begin
             if Reg.DeleteValue(ApTitle) then
                ShowMessage('Key Removed: ' + ApTitle)
             else
                 ShowMessage('Key Not found: ' + ApTitle);
        end;

        Reg.CloseKey;
     finally
            FreeAndNil(Reg);
     end;
end;
