// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Open a File using its associated application
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

function OpenFile(AFile: string; ADir: string = nil; AParams: string = nil): boolean
;
begin
  result := ShellExecute(Application.Handle, ’open’, PChar(AFile), ADir, AParams,
    SW_SHOWNORMAL) >= 32;
end;           
