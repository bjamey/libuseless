// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check and Register File Association
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit file_association;

interface

uses
    SysUtils, Registry, WinTypes, ShellAPI;

    function RegisterAssociation(const aExeName, aFileExt, aFileDesc, aFileIcon: string): Boolean;
    function ShellFindExecutable(const FileName, DefaultDir: string): string;

implementation

//------------------------------------------------------------------------//
function RegisterAssociation(const aExeName, aFileExt, aFileDesc, aFileIcon: string): Boolean;
{
  This function registers a file association.

  ExeName   is the full path and name of the exe that will be associated
            with the extension.
  FileExt   is the extension of the file to register i.e. ".dxf" or ".ord".
  FileDesc  is the description of the file. i.e. "Drawing Exchange File".
  FileIcon  is the location of the icon to associate with this file type.
            For example "C:\MyApplicationLocation\Myapplication.exe,0"
            Note the ",0" means use the icon associated with the .exe.
            You can also say ",1" to use the next icon, if one exists.
            Or you can pass the name of the icon itself such as:
            "C:\MyApplication\Icons\MyIcon.ico".
  Note: You may have to re-boot the PC before the associated icon will
        change.
  Note: When end user double clicks on the registered file type, your .exe
        will launch, and the file name will be passed via ParamStr(1).
        (If the file name contains spaces, then it may also be passed in
         ParamStr(2), etc.)
}
var
   sFileClass, sFileExt: string;
begin
     Result := False;

     sFileExt := Trim(aFileExt);
     if Length(sFileExt) = 0 then Exit;

     if (sFileExt[1] <> '.') then
        sFileExt := '.' + sFileExt;

     sFileClass := Copy(sFileExt, 2, Length(sFileExt)) + 'file';

     with TRegistry.Create do
     begin
          try
             RootKey := HKEY_CLASSES_ROOT;

             if OpenKey(sFileExt, True) then
             begin
                  WriteString('', sFileClass);
                  CloseKey;
             end;

             if OpenKey(sFileClass, True) then
             begin
                  WriteString('', aFileDesc);
                  CloseKey;
             end;

             if OpenKey(sFileClass + '\Shell\Open', True) then
             begin
                  WriteString('', '&Open');
                  CloseKey;
             end;

             if OpenKey(sFileClass + '\Shell\Open\command', True) then
             begin
                  WriteString('', aExeName + ' %1');
                  CloseKey;
                  Result := True;
             end;

             // Register an icon file with the application.
             if OpenKey(sFileClass + '\DefaultIcon', True) then
             begin
                  WriteString('', aFileIcon);
                  CloseKey;
             end;
          finally
                 Free;
          end;
     end;
end;
//------------------------------------------------------------------------//
function ShellFindExecutable(const FileName, DefaultDir: string): string;
var
   Res: HINST;
   Buffer: array[0..MAX_PATH] of Char;
   P: PChar;
begin
     FillChar(Buffer, SizeOf(Buffer), #0);
     if DefaultDir = '' then
        P := nil
     else
         P := PChar(DefaultDir);

     Res := FindExecutable(PChar(FileName), P, Buffer);
     if (Res > 32) then
     begin
          P := Buffer;
          while PWord(P)^ <> 0 do
          begin
               if P^ = #0 then // FindExecutable replaces #32 with #0
                  P^ := #32;
               Inc(P);
          end;

          Result := Buffer;
     end
     else
         Result := '';
end;
//------------------------------------------------------------------------//
end.
