// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check if connected to the network  internet or not
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

{ ------------------------------
  Check if connected to
  the network / internet or not
------------------------------ }

const
   INTERNET_CONNECTION_MODEM          = 1;
   INTERNET_CONNECTION_LAN            = 2;
   INTERNET_CONNECTION_PROXY          = 4;
   INTERNET_CONNECTION_MODEM_BUSY     = 8;

function InternetGetConnectedState(lpdwFlags: LPDWORD;
         dwReserved: DWORD): BOOL; stdcall; external 'WININET.DLL';

function IsConnectedToInternet() : boolean;
var
   dwConnectionTypes: Integer;
begin
     try
        dwConnectionTypes := INTERNET_CONNECTION_MODEM +
                             INTERNET_CONNECTION_LAN +
                             INTERNET_CONNECTION_PROXY;

        if InternetGetConnectedState(@dwConnectionTypes, 0) then
           Result := true
        else
            Result := false;
     except
           Result := false;
     end;
end;

// ---------
// Usage:
// ---------

if IsConnectedToInternet then
   // do something, we are connected
else
    // No active connection
