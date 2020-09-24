// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Power management procedure (shutdown,log off, screensaver, etc)
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Power management procedure (shutdown,log off, screensaver, etc)

function PowerMng(Action : Integer; Force : Boolean) : boolean;
var
   rl: Cardinal;
   hToken: Cardinal;
   tkp: TOKEN_PRIVILEGES;
begin
   if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    begin
         // Get access to windows privilege
         OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);
         LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
         tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;;
         tkp.PrivilegeCount := 1;
         AdjustTokenPrivileges(hToken, False, tkp, 0, nil, rl);

         // Shutdown Windows
         if (Action = 1) and (Force = False) then
         begin
               ExitWindowsEx(EWX_SHUTDOWN, 0);
         end
         else if (Action = 1) And (Force = True) then
         begin
              ExitWindowsEx(EWX_SHUTDOWN OR EWX_FORCE, 0);
         end;

         // Restart/Reboot Windows
         if (Action = 2) and (Force = false) then
         begin
              ExitWindowsEx(EWX_REBOOT, 0)
         end
         else if (Action = 2) and (Force = true) then
         begin
              ExitWindowsEx(EWX_REBOOT or EWX_FORCE, 0);
         end;                                                                                             

         // Log Off Windows
         if (Action = 3) and (Force=false) then
         begin
              ExitWindowsEx(EWX_LOGOFF, 0);
         end
         else if (Action = 3) and (Force = true) then
         begin
              ExitWindowsEx(EWX_LOGOFF or EWX_FORCE, 0);
         end;

         // Turn off monitor
         if (Action = 4) And (Force = true) then
         begin
              SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
         end
         else if (Action = 4) and (Force = true) then // Turn ON monitor
         begin
              SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, 0);
         end;

         // Activating screensaver
         if (Action = 5) then
         begin
              DefWindowProc(Form1.Handle, WM_SYSCOMMAND, SC_SCREENSAVE, 0);
         end;
    end;
end;
