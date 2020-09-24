// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Check if connected to the network  internet or not (2)
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses IWinInet;
...
procedure CheckConnection;
var
  dwFlags: DWORD;
begin
  if InternetGetConnectedState(@dwFlags, 0) then
  begin
    if (dwFlags and INTERNET_CONNECTION_MODEM)=INTERNET_CONNECTION_MODEM then
      ShowMessage(’Connected through modem’)
    else if (dwFlags and INTERNET_CONNECTION_LAN) = INTERNET_CONNECTION_LAN then
      ShowMessage(’Connected through LAN’)
    else if (dwFlags and INTERNET_CONNECTION_PROXY) = INTERNET_CONNECTION_PROXY then
      ShowMessage(’Connected through Proxy’)
    else if (dwFlags and INTERNET_CONNECTION_MODEM_BUSY) = INTERNET_CONNECTION_MODEM_BUSY then
      ShowMessage(’Modem is busy’);
  end
  else
    ShowMessage(’Offline’);
end;                               
