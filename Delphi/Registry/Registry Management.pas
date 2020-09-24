// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Registry Management
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
  if not ReadKeys then
  begin
    WriteKeys;
    ReadKeys;
  end;
end;


// ------------
// Form Destroy
// ------------
procedure TForm1.FormDestroy(Sender: TObject);
begin
  WriteKeys;
  Reg.Free;
end;


// ----------
// Write keys
// ----------
procedure TForm1.WriteKeys;
begin
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\MySoftwareHouse\' + Application.Title, true) then
    begin
      try Reg.WriteString('Edit1', E_Edit1.Text) except end;
      try Reg.WriteString('Edit2', E_Edit2.Text) except end;
      try Reg.WriteString('Edit3', E_Edit3.Text) except end;
      Reg.CloseKey;
    end;

  // Directory shell integration (open here...)
  
  Reg.RootKey := HKEY_CLASSES_ROOT;
  if Reg.OpenKey('Directory\shell\' + Application.Title, true) then
    begin
      try Reg.WriteString ('', 'Open... (with MyProgram)') except end;
      Reg.CloseKey;
    end;
  if Reg.OpenKey('Directory\shell\' + Application.Title + '\Command', true) then
    begin
      try Reg.WriteString ('', '"' + Application.ExeName + '" "%1"') except end;
      Reg.CloseKey;
    end;

  ...

  // Remove Directory shell integration (open here...)

  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.DeleteKey('Directory\shell\' + Application.Title);

end


// ---------
// Read keys:  -> Return true if keys readed, false if keys not found <-
// ---------
function TForm1.ReadKeys: boolean;
begin
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\MySoftwareHouse\' + Application.Title, false) then
    begin
      try E_Edit1.Text := Reg.ReadString('Edit1'); except end;
      try E_Edit2.Text := Reg.ReadString('Edit2'); except end;
      try E_Edit3.Text := Reg.ReadString('Edit3'); except end;
      Reg.CloseKey;
      Result := true;
    end
  else
    Result := false;
  end;

