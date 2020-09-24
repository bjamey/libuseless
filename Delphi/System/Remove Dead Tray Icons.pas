// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Remove Dead Tray Icons
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Remove Dead Tray Icons

procedure RemoveDeadIcons();
var
   TrayWindow : HWnd;
   WindowRect : TRect;
   SmallIconWidth : Integer;
   SmallIconHeight : Integer;
   CursorPos : TPoint;
   Row : Integer;
   Col : Integer;
begin
     // Get tray window handle and bounding rectangle
     TrayWindow := FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0, 'TrayNotifyWnd', nil);
     if not GetWindowRect(TrayWindow,WindowRect) then
        Exit;

     // Get small icon metrics
     SmallIconWidth := GetSystemMetrics(SM_CXSMICON);
     SmallIconHeight := GetSystemMetrics(SM_CYSMICON);

     // Save current mouse position
     GetCursorPos(CursorPos);

     // Sweep the mouse cursor over each icon in the tray in
     // both dimensions
     with WindowRect do
     begin
          for Row := 0 to (Bottom - Top) DIV SmallIconHeight do
          begin
               for Col := 0 to (Right - Left) DIV SmallIconWidth do
               begin
                    SetCursorPos(Left + Col * SmallIconWidth, Top + Row * SmallIconHeight);
                    Sleep(0);
               end;
          end;
     end;

     // Restore mouse position
     SetCursorPos(CursorPos.X,CursorPos.Y);

     // Redraw tray window (to fix bug in multi-line tray area)
     RedrawWindow(TrayWindow, nil, 0, RDW_INVALIDATE OR RDW_ERASE OR RDW_UPDATENOW);
end;
