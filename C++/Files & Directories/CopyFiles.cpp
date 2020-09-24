// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: CopyFiles
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------
//
// Input: AnsiString Source      = Source folder path
//        bool       Destination = Destination folder path
//        bool       SubDir      = if true, copy also subdirectories
//
// ----------------------------------------------------------------------------

void __fastcall CopyFiles (AnsiString Source, AnsiString Destination, bool SubDir)
{
 //Search result structure.
 TSearchRec File;

 // FindFirst and FindNext returns 0 if file found.

 if ((FindFirst(Source+"*.*", faArchive, File)) == 0)
   do {
     //If not system file
     if(File.Attr != faSysFile)
       CopyFile ((Source + File.Name).c_str(), (Destination + File.Name).c_str(), false);
   } while (FindNext(File) == 0);

   FindClose(File);

   if(SubDir) {
     // Search for subdirectory... and create if exist
     if ((FindFirst(Source + "*.*", faDirectory, File)) == 0)
       do {
         if ((File.Name != ".")&&(File.Name != "..")) {
           if (!DirectoryExists(Destination + File.Name))
             ForceDirectories(Destination + File.Name); // Create if not exist
           CopyFiles (Source + File.Name, Destination + File.Name, true);
         }
       }while (FindNext(File) == 0);
    
    FindClose(File);
   }
}                           
