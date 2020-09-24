// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
//
// Title: Get real file path from a shortcut (*.lnk)
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* --------------------------------------------
   Get *real* file path from a shortcut (*.lnk)
   --
   Required units: ShlObj, ActiveX
-------------------------------------------- *)

function GetExeFromLink(FileName : String) : String;
var
   IntfShelllink : IShellLink;
   intfFile : IPersistFile;
   fwName : WideString;
   DirName : String;
   pDirName : PChar;
   Data : win32_find_data;
begin
      // Get *real* file path from a shortcut (*.lnk)

      fwName := FileName;
      IntfShelllink := CreateComObject(CLSID_Shelllink) as IShellLink;
      intfFile := IntfShelllink as IPersistFile;
      intfFile.Load(pwchar(fwname), STGM_READ);
      Setlength(DirName, MAX_PATH);
      pDirName := PChar(DirName);
      IntfShelllink.GetPath(pDirName, max_path, Data, 0);

      Result := pDirName;
end;       
