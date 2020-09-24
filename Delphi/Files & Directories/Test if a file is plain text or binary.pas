// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Test if a file is plain text or binary
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -------------------------------------
 Test if a file is plain text or binary
------------------------------------- *)

function IsBinaryFile(FileName : String) : Boolean;
var
   F : File of byte;
   Hit : boolean;
   i : Integer;
   A : Byte;
begin
     if Not FileExists(FileName) then
     begin
          Result := False;
          Exit;
     end;

     Assign(F, FileName);

     Reset(F);  // , 1);
     Hit := False;
     i := 0;

     repeat
           Read(F, A);
           if (A < 7) OR ((A >= 14) And (A <= 31)) then Hit := True;
           Inc(i);
     until EOF(F) OR Hit OR (i >= 512);

     (*
       Note: Remove the (i >= 512) condition if you want to test
       the whole file
      // *)

     CloseFile(F);

     Result := Hit;
end;
