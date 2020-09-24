// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Test if program is running inside IDE
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Test if program is running inside IDE
function InsideIDE(): Boolean;
begin
     Result := (DebugHook <> 0);
end;      
