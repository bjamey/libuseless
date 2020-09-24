// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Ini File Management
//
// Date : 15/02/2006
// By   : FSL
// ----------------------------------------------------------------------------

uses
  IniFiles;

  {...}

private
  MyIni: TIniFile;

  {...}

// -----------
// Read Setup
// -----------
procedure TForm1.ReadSetup;
begin
  MyIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Edit1.Text := MyIni.ReadString('Setup', 'Edit 1', 'Default Text');
    IntegerVar := MyIni.ReadInteger('Setup', 'Integer Value', 0);
    BooleanVar := MyIni.ReadBool('Setup', 'Boolean Value', True);
  finally
    MyIni.Free;
  end;
end;

// -----------
// Write Setup
// -----------
procedure TForm1.WriteSetup;
begin
  MyIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    MyIni.WriteString('Setup', 'Edit 1', Edit1.Text);
    MyIni.WriteInteger('Setup', 'Integer Value', IntegerVar);
    MyIni.WriteBool('Setup', 'Boolean Value', BooleanVar);
  finally
    MyIni.Free;
  end;
end;
