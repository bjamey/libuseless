// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Capture mouse clicks at statusbar
//
// Date : 14/04/2009
// By   : FSL 
// ----------------------------------------------------------------------------

uses
  Windows, Messages, Forms, Classes, SysUtils, Controls, ComCtrls, Commctrl; 
  
type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    procedure WMNotify(var AMsg: TWMNotify); message WM_NOTIFY;
  end; 
  
...    

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 3 do
    with StatusBar1.Panels.Add do
    begin
      Width := 100;
      Text := Format(’Panel %d’,[i]);
    end;                                        
end;

procedure TForm1.WMNotify(var AMsg: TWMNotify);
var
  pNMM: PNMMouse;
  ctrl: TWinControl;
  hWindow: HWND;
  iPanel: integer;
begin
  inherited;
  pNMM := PNMMouse(AMsg.NMHdr);
  hWindow := pNMM^.hdr.hwndFrom;
  ctrl := FindControl(hWindow);
  iPanel := pNMM^.dwItemSpec;
  case pNMM^.hdr.code of
  NM_CLICK:
  Caption := Format(’%s was clicked at panel %d’,[ctrl.Name,iPanel]);
  NM_DBLCLK:
  Caption := Format(’%s was double-clicked at panel %d’,[ctrl.Name,iPanel]);
  NM_RCLICK:
  Caption := Format(’%s was right-clicked at panel %d’,[ctrl.Name,iPanel]);
  NM_RDBLCLK:
  Caption := Format(’%s was right-double-clicked at panel %d’,[ctrl.Name,iPanel]);
  end;
end;                 
