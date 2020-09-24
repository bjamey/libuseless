// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert SWF to EXE using Delphi
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ------------------------------------------------------
   Converting SWF to EXE using Delphi

   --
   Example code :

   Swf2Exe('C:\somefile.swf', 'C:\somefile.exe', 'C:\Program Files\MacromediaFlash MX\Players\SAFlashPlayer.exe');
------------------------------------------------------ *)

function Swf2Exe(SourceSWF, exeFile, FlashPlayer : string): string;
var
   SourceStream, DestinyStream, LinkStream : TFileStream;
   flag : Cardinal;
   SwfFileSize : integer;
begin
     result := 'Error';
     DestinyStream := TFileStream.Create(exeFile, fmCreate);
     try
        LinkStream := TFileStream.Create(FlashPlayer, fmOpenRead or fmShareExclusive);
        try
           DestinyStream.CopyFrom(LinkStream, 0);
        finally
               LinkStream.Free;
        end;

        SourceStream := TFileStream.Create(SourceSWF, fmOpenRead or fmShareExclusive);
        try
           DestinyStream.CopyFrom(SourceStream, 0);
           flag := $FA123456;
           DestinyStream.WriteBuffer(flag, sizeof(integer));
           SwfFileSize := SourceStream.Size;
           DestinyStream.WriteBuffer(SwfFileSize, sizeof(integer));
           result := '';
        finally
               SourceStream.Free;
        end;
     finally
            DestinyStream.Free;
     end;
end;
// --------------------------------------------------- //
