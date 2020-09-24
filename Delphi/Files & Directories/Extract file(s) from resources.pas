// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Extract file(s) from resources
//
//        Extract file(s) from resources to WorkDir (or delete it from WorkDir)
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

type
  TExtractDelete = (edExtract, edDelete);  


procedure ExtractEXE (const Action: TExtractDelete);
begin
  SetCurrentDir(WorkDir);

  if Action = edExtract then
    begin
      ExtractRes('EXEFILE', 'MY_EXE1', WorkDir + 'file1.exe');
      ExtractRes('EXEFILE', 'MY_EXE2', WorkDir + 'file2.exe');
    end
  else
    Begin
      if FileExists(workdir + 'file1.exe') then
        DeleteFile(workdir + 'file1.exe');
      if FileExists(workdir + 'file2.exe') then
        DeleteFile(workdir + 'file2.exe');
    end;
end;


{

  MYRES.RC file:

MY_EXE1 EXEFILE file1.exe
MY_EXE2 EXEFILE file2.exe


  BUILDRES.BAT file:
                                   
tasm\brc32 -r MYRES.RC

}
