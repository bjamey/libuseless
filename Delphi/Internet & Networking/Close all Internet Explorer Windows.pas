// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Close all Internet Explorer Windows
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

procedure CloseIE();
var
   IExplorer : Thandle;
begin
     IExplorer := FindWindow('IEFrame',nil);
     If IExplorer <> 0 Then
        SendMessage(IExplorer, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;
