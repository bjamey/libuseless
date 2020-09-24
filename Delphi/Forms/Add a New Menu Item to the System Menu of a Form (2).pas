// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Add a New Menu Item to the System Menu of a Form (2)
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

type   
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  end; 
  
...    

const
  ID_ABOUT = WM_USER + 1; 
  
procedure TForm1.FormCreate(Sender: TObject);
var
  hSysMenu: HMENU;
begin
  hSysMenu := GetSystemMenu(Handle, false);
  AppendMenu(hSysMenu, MF_SEPARATOR, 0, nil);
  AppendMenu(hSysMenu, MF_STRING, ID_ABOUT, PChar(’&About...’));
end;

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = ID_ABOUT then
    AboutForm.ShowModal
  else
    inherited;
end;          
