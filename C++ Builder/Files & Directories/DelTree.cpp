// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: DelTree
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------
//
// Input: AnsiString Path   = Path to base folder to clean
//        bool       DelDir = if true, remove base folder
//        bool       SubDir = ff true, remove also subdirectories
// ----------------------------------------------------------------------------

void __fastcall DelTree (AnsiString Path, bool DelDir, bool SubDir)
{
 //Struttura risultato della ricerca.
 TSearchRec File;

 // FindFirst and FindNext returns 0 if file found.

 if ((FindFirst(Path+"\\*.*", faArchive, File)) == 0)
   do {
     //If not system file
     if(File.Attr != faSysFile)
       DeleteFile (Path + "\\" + File.Name);
   } while (FindNext(File) == 0);

   FindClose(File);

   if(SubDir) {
     // Search subfolder... remove if exist
     if ((FindFirst(Path + "\\*.*", faDirectory, File)) == 0)
       do {
         if ((File.Name != ".")&&(File.Name != ".."))
          DelTree (Path + "\\" + File.Name, true, true);
       } while (FindNext(File) == 0);
    FindClose(File);
   }

 // Remove main directory if required
 if(DelDir)
    RemoveDir(Path);
}
