// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Desktop Refresh
//
// Date : 03/02/2006
// By   : FSL
// ----------------------------------------------------------------------------

{
Call the following procedure to 
refresh the Desktop window from
your Delphi app. 
}

procedure RefreshDesktop; 
var 
  hDesktop: HWND; 
begin 
  hDesktop := FindWindowEx(
                FindWindowEx(
                  FindWindow('Progman', 'Program Manager')
                , 0, 'SHELLDLL_DefView', '')
              , 0, 'SysListView32', '');
  PostMessage(hDesktop, WM_KEYDOWN, VK_F5, 0);
  PostMessage(hDesktop, WM_KEYUP, VK_F5, 1 shl 31); 
end; 

                                    
