// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Is Running Windows 7
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

  function IsWindows7: Boolean;
var
   VerInfo: TOSVersioninfo;
begin
     VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
     GetVersionEx(VerInfo);
     Result := VerInfo.dwMajorVersion >= 7;
end;    
