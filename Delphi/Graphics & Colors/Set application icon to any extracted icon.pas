// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Set application icon to any extracted icon
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -----------------------------------------
   Set the app icon to it's Exe icon
   must have 'Forms' in the uses clause
   (For the Application.ExeName)      }
----------------------------------------- *)

procedure SetAppIcon(Const sIconSource : String = Application.ExeName);
begin
     Application.Icon.Handle := ExtractIconA(Handle, Pchar(sIconSource), 0);
end;    
