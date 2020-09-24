// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get the MAC Address of Network Device
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function MacAddress: string;
var
   Lib: Cardinal;
   Func: function(GUID: PGUID): Longint; stdcall;
   GUID1, GUID2: TGUID;
begin
     Result := '';

     Lib := LoadLibrary('rpcrt4.dll');
     if (Lib <> 0) then
     begin
        @Func := GetProcAddress(Lib, 'UuidCreateSequential');
        if Assigned(Func) then
        begin
          if (Func(@GUID1) = 0) and
             (Func(@GUID2) = 0) and
             (GUID1.D4[2] = GUID2.D4[2]) and
             (GUID1.D4[3] = GUID2.D4[3]) and
             (GUID1.D4[4] = GUID2.D4[4]) and
             (GUID1.D4[5] = GUID2.D4[5]) and
             (GUID1.D4[6] = GUID2.D4[6]) and
             (GUID1.D4[7] = GUID2.D4[7]) then
          begin
                Result := IntToHex(GUID1.D4[2], 2) + '-' +
                          IntToHex(GUID1.D4[3], 2) + '-' +
                          IntToHex(GUID1.D4[4], 2) + '-' +
                          IntToHex(GUID1.D4[5], 2) + '-' +
                          IntToHex(GUID1.D4[6], 2) + '-' +
                          IntToHex(GUID1.D4[7], 2);
          end;
        end;
     end;
end;
