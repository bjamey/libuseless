// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Retrieve system IP Address
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ---------------------------------------------------
  Retrieve system IP Address
  --
  Required unit: Winsock
--------------------------------------------------- *)

function GetIPs() : TStrings;
type
    TaPInAddr = array[0..10] of PInAddr;
    PaPInAddr = ^TaPInAddr;
var
   phe : PHostEnt;
   pptr : PaPInAddr;
   Buffer : array[0..63] of Char;
   i : Integer;
   GInitData : TWSAData;
begin
     WSAStartup($101, GInitData);

     Result := TStringList.Create;
     Result.Clear;
     GetHostName(Buffer, SizeOf(Buffer));
     phe := GetHostByName(buffer);
     if phe = nil then Exit;

     pPtr := PaPInAddr(phe^.h_addr_list);
     I    := 0;
     while pPtr^[I] <> nil do
     begin
          Result.Add(inet_ntoa(pptr^[I]^));
          Inc(I);
     end;

     WSACleanup;
end;
