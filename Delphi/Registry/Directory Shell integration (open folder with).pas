// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Directory Shell integration (open folder with...)
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Registry;

  {...}

private
  Reg: TRegistry;

  {...}


// -----------
// Form Create
// -----------
procedure TForm1.FormCreate(Sender: TObject);
begin
  Reg := TRegistry.Create;
end;


// ------------
// Form Destroy
// ------------
procedure TForm1.FormDestroy(Sender: TObject);
begin
  Reg.Free;
end;


// -------------------------------------------------
// Enable Directory shell integration (open with...)
// -------------------------------------------------
procedure EnableDirectoryIntegration;
begin
  Reg.RootKey := HKEY_CLASSES_ROOT;
  if Reg.OpenKey('Directory\shell\' + Application.Title, true) then
    begin
      try Reg.WriteString ('', 'Find... (with zFind)') except end;
      Reg.CloseKey;
    end;
  if Reg.OpenKey('Directory\shell\' + Application.Title + '\Command', true) then
    begin
      try Reg.WriteString ('', '"' + Application.ExeName + '" "%1"') except end;
      Reg.CloseKey;
    end;
end;
  

// -------------------------------------------------
// Remove Directory shell integration (open here...)
// -------------------------------------------------
procedure RemoveDirectoryIntegration;
begin
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.DeleteKey('Directory\shell\' + Application.Title);
end;
