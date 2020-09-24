// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Associate File extension with Executable (and Icon)
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Registry;

// ---------------
// Associate files
// ---------------
procedure TMainForm.SetupExtension;
var
    Reg: TRegistry;
begin
    Reg := TRegistry.Create;

    //------------------------------------------------
    // Associate '.TRY' files with 'MyProgram' program
    //------------------------------------------------
    reg.RootKey := HKEY_CLASSES_ROOT;
    reg.LazyWrite := false;

    // Associate .TRY extension with MyProgram.Project key

    reg.OpenKey('.try', true);
    reg.WriteString('', 'MyProgram.Project');
    reg.CloseKey;

    // Write: file type description

    reg.OpenKey('MyProgram.Project', true);
    reg.WriteString('', 'MyProgram try file');
    reg.CloseKey;

    // Call program with attached filename parameter

    reg.OpenKey('MyProgram.Project\shell\open\command', true);
    reg.WriteString('', Application.ExeName + ' "%1"');
    reg.CloseKey;

    // Use first executable icon as '.TRY' file icon

    reg.OpenKey('MyProgram.Project\DefaultIcon',true);
    reg.WriteString('', Application.ExeName + ',1');
    reg.CloseKey;

  Reg.Free;
end;
