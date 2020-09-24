// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Delphi’s equivalent of the VB’s App object
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

// Go to Project | Options and ?ll in the ?elds in Application page and Version info page.

unit AppUnit;

interface

type
  TApp = class
    protected
     //if the constructor is declared as protected then the
     //class can be instantiated only within this unit
     constructor Create;
   public
    Title: string;
    Path: string;
    ExeName: string;
    HelpFile: string;
    FileDescription: string;
    FileVersion: string;
    ProductName: string;     
...
  end; 
  
var
  App: TApp;   
  
implementation

uses
  SysUtils, StrUtils, Forms, Windows, Dialogs;

type
  PLongInt = ^Longint;

constructor TApp.Create;
var
  nBytes, nInfoLen: DWORD;
  psBuffer: PChar;
  pntValue: Pointer;
  iLangID, iCharSetID: Word;
  strID: string;
begin
  ExeName := Application.ExeName;
  Path := ExtractFilePath(ExeName);
  if RightStr(Path,1) <> ’\’ then
    Path := Path + ’\’;
  Title := Application.Title;
  HelpFile := Application.HelpFile;
  nBytes := GetFileVersionInfoSize(PChar(ExeName), nBytes);
  if nBytes = 0 then
  begin
    ShowMessage(’No version information available!’);
    exit;
  end;
  psBuffer := AllocMem(nBytes + 1);
  GetFileVersionInfo(PChar(ExeName), 0, nBytes, psBuffer)
  VerQueryValue(psBuffer, ’\VarFileInfo\Translation’, pntValue, nInfoLen)
  iLangID := LoWord(PLongint(pntValue)^);
  iCharSetID := HiWord(PLongint(pntValue)^);
  strID := Format(’\StringFileInfo\%.4x%.4x\’, [iLangID, iCharSetID]);
  if VerQueryValue(psBuffer, PChar(strID + ’FileDescription’), pntValue, nInfoLen) then
    FileDescription := AnsiReplaceStr(PChar(pntValue), ’\n’, #13#10);
  if VerQueryValue(psBuffer, PChar(strID + ’FileVersion’), pntValue, nInfoLen) then
  FileVersion := PChar(pntValue);
  if VerQueryValue(psBuffer, PChar(strID + ’ProductName’), pntValue, nInfoLen) then
    ProductName := PChar(pntValue);
  FreeMem(psBuffer, nBytes);
end;

initialization
  App := TApp.Create;

finalization
  App.Free;  
end.
