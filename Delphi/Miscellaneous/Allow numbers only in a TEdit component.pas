// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Allow numbers only in a TEdit component
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -----------------------------------------
   Allow numbers only in a TEdit component
   --
   If you also want to have a right aligned
   number, send additionally the ES_RIGHT
   flag there
----------------------------------------- *)

procedure SetNumericOnly(aEdit : TEdit);
var
   defstyle: dWord;
begin
     defstyle := GetWindowLong(aEdit.Handle, GWL_STYLE);
     SetWindowLong(aEdit.Handle, GWL_STYLE, defstyle OR ES_NUMBER);
end;
