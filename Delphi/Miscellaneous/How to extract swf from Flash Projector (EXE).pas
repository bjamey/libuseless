// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to extract swf from Flash Projector (EXE)
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// How to extract swf from Flash Projector (EXE)

procedure ExtractSWF(exeFile : String);
var
   p : pointer;
   F : file;
   sz, swfsize : integer;
const
     SWF_FLAG : integer = $FA123456;
begin
     if not FileExists(exeFile) then
     begin
          // MessageBox(handle,pchar('File not found'),pchar('Error'),MB_ICONERROR);
          Exit;
     end;

     AssignFile(F, exeFile);
     Reset(F, 1);
     Seek(F, FileSize(F) - (2 * sizeof(integer)));
     BlockRead(F, sz, sizeof(integer));

     if sz <> swf_flag then
     begin
          // messagebox(handle,pchar('Not a valid Projector Exe'),pchar('Error'),MB_ICONERROR);
          CloseFile(f);
          Exit;
     end;

     blockread(f,swfsize,sizeof(integer));
     Seek(F,FileSize(F) - (2 * sizeof(integer)) - swfsize);
     GetMem(p, swfsize);
     BlockRead(F, p^, swfsize);
     CloseFile(F);
     AssignFile(F, exeFile));
     Rewrite(F, 1);
     BlockWrite(F, p^, swfsize);
     CloseFile(F);
     FreeMem(p, swfsize);
     // MessageBox(handle,pchar('SWF Extracted'),pchar('Succes'),MB_ICONINFORMATION);
end;
