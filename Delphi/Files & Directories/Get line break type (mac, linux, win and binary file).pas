// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get line break type (mac, linux, win and binary file)
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

//  -------------------------------------------
//   This code analyses the first 5*1024 bytes
//   of data from a file and tells which break
//   type it uses, or if it's a binary file...
//                                                   
//   Autor: Jonas Raoni Soares Silva
//   Site: http://www.joninhas.ath.cx:666
//  -------------------------------------------

type
    TBreakType = (btNone, btWin, btMac, btLinux, btBinary);

// ----------------------------------------------------------
function GetBreakType(const FileName: string; const MaxDataToRead: Cardinal = 5 * 1024): TBreakType;
var
   FS: TFileStream;
   Buffer, BufferStart, BufferEnd: PChar;
begin
     Result := btNone;

     if Not FileExists(FileName) then
        raise Exception.Create('GetBreakType: File does NOT exist.' );
     try
        FS := TFileStream.Create(FileName, fmOpenRead);
        GetMem(Buffer, MaxDataToRead + 1);
        BufferEnd := (Buffer + FS.Read(Buffer^, MaxDataToRead));
        BufferStart := Buffer;
        BufferEnd^ := #0;
     except
           raise Exception.Create( 'GetBreakType: error while trying to allocate memory' );
     end;

     try
        while Buffer^ <> #0 do
        begin
             if Result = btNone then
                if Buffer^ = ASCII_CR then
                begin
                     if (Buffer+1)^ = ASCII_LF then
                     begin
                          Result := btWin;
                          Inc(Buffer);
                     end
                     else
                         Result := btMac;
                end
                else if Buffer^ = ASCII_LF then
                     Result := btLin;

             Inc(Buffer);
        end;

        if Buffer <> BufferEnd then
           Result := btBin;
     finally
            FreeMem(BufferStart, MaxDataToRead + 1);
            FS.Free;
     end;
end;
// ---------------------------------------------------------- //
