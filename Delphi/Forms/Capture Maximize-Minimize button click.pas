// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Capture Maximize-Minimize button click
//
// Date : 15/02/2006
// By   : FSL
// ----------------------------------------------------------------------------

...

type
  TForm1 = class(Form)
  
  ...

public
  procedure WMSysCommand (var Msg: TWMSysCommand);
  message WM_SYSCOMMAND;

{...}

implementation

{...}

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType = SC_MINIMIZE)
  or (Msg.CmdType = SC_MAXIMIZE)
  or (Msg.CmdType = SC_CLOSE) then
    MessageBeep(0)
  else
    DefaultHandler(Msg) ;
end;
