// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Empty Recycle Bin
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  ShellApi,Controls, Forms, Dialogs,StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    procedure EmptyRecycleBin();
  end;

var
  Form1: TForm1;

function SHEmptyRecycleBin(Wnd:HWnd; LPCTSTR:PChar; DWORD:Word):Integer; stdcall;

const
     SHERB_NOCONFIRMATION   = $00000001;
     SHERB_NOPROGRESSUI     = $00000002;
     SHERB_NOSOUND          = $00000004;

implementation

{$R *.DFM}

function SHEmptyRecycleBin; external 'SHELL32.DLL' name 'SHEmptyRecycleBinA';

// ---------------------------------------------------------- //
procedure TForm1.EmptyRecycleBin();
begin
     // TForm1
     SHEmptyRecycleBin(self.handle,'',SHERB_NOCONFIRMATION);
end;
// ---------------------------------------------------------- //
end.
