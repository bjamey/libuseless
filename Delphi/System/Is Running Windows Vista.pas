// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Is Running Windows Vista
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function IsWindowsVista: Boolean;
var
   VerInfo: TOSVersioninfo;
begin
     VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
     GetVersionEx(VerInfo);
     Result := VerInfo.dwMajorVersion >= 6;
end;                               
