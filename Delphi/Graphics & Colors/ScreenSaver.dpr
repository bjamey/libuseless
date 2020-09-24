// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: ScreenSaver
//
//        Basic ScreenSaver skeleton
//
// Note:  Change executable file extension from .exe to .scr
//
// Date :
// By   : Stefano
// ----------------------------------------------------------------------------


program ScreenSaver;

uses
  Forms,
  scr in 'scr.pas' {F_Screensaver},
  config in 'config.pas' {F_Configuration},
  preview in 'preview.pas' {F_Preview};

{$R *.res}

begin                            
  if Length(paramstr(1)) > 1 then
  begin
    Application.Initialize;

    // ScreenSaver
    if paramstr(1)[2] = 's' then
    begin
      Application.CreateForm(TF_Screensaver, F_Screensaver);
      Application.Run;
    end;

    // Configuration form
    if paramstr(1)[2] = 'c' then
    begin
      Application.CreateForm(TF_Configurazione, F_Configurazione);
      Application.Run;
    end;

    // Preview (into preview window)
    if paramstr(1)[2] = 'p' then
    begin
      Application.CreateForm(TF_Preview, F_Preview);
      Application.Run;
    end;                             

  end;
end.
