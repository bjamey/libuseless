// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to set the screen resolution
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// How to set the screen resolution.

procedure SetResolution(XRes, YRes: DWord);
var
   lpDevMode : TDeviceMode;
begin
     EnumDisplaySettings(nil, 0, lpDevMode);

     lpDevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
     lpDevMode.dmPelsWidth := XRes;
     lpDevMode.dmPelsHeight := YRes;

     ChangeDisplaySettings(lpDevMode, 0);
end;
