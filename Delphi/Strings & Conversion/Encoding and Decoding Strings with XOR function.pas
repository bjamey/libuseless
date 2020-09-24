// -----------------------------------------------------------------------------
//                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
//  Title: Encoding and Decoding Strings with XOR function
//
//  Date : 15/05/2007
//  By   : FSL
// -----------------------------------------------------------------------------

(* ----------
  Code :
---------- *)

function XorStr(Stri, Strk: String): String;
var
    Longkey: string;                                     
    I: Integer;
    Next: char;
begin
     for i := 0 to (Length(Stri) div Length(Strk)) do
         Longkey := Longkey + Strk;

     for I := 1 to length(Stri) do
     begin
          Next := chr((ord(Stri[i]) xor ord(Longkey[i])));
          Result := Result + Next;
     end;
end;

(* ---------------
  Example:
--------------- *)

procedure TForm1.Button1Click(Sender: TObject);
begin
    { Encode The String }
    Edit1.Text := XorStr('The String', '1234567890');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    { Decode The String }
    Edit2.Text := XorStr(Edit1.Text, '1234567890');
end;
