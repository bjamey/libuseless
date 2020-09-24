// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Retrieve Windows special folders
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Required Unit: ShlObj

function GetSystemPath(Folder: Integer): string;
var
   PIDL: PItemIDList;
   Path: LPSTR;
   AMalloc: IMalloc;
begin
     Path := StrAlloc(MAX_PATH);
     SHGetSpecialFolderLocation(Application.Handle, Folder, PIDL);
     if SHGetPathFromIDList(PIDL, Path) then Result := Path;

     SHGetMalloc(AMalloc);
     AMalloc.Free(PIDL);
     StrDispose(Path);
end;

(* -------------------
   Folders Constants
------------------- *)

// (*
const
  SHGFP_TYPE_CURRENT  = 0;   // current value for user, verify it exists
  SHGFP_TYPE_DEFAULT  = 1;   // default value, may not exist
  CSIDL_PERSONAL             = $0005;  // My Documents
  CSIDL_APPDATA              = $001A;  // Application Data, new for NT4
  CSIDL_LOCAL_APPDATA        = $001C;  // non roaming, user\Local Settings\Application Data
  CSIDL_INTERNET_CACHE       = $0020;
  CSIDL_COOKIES              = $0021;
  CSIDL_HISTORY              = $0022;
  CSIDL_COMMON_APPDATA       = $0023;  // All Users\Application Data
  CSIDL_WINDOWS              = $0024;  // GetWindowsDirectory()
  CSIDL_SYSTEM               = $0025;  // GetSystemDirectory()
  CSIDL_PROGRAM_FILES        = $0026;  // C:\Program Files
  CSIDL_MYPICTURES           = $0027;  // My Pictures, new for Win2K
  CSIDL_PROGRAM_FILES_COMMON = $002B;  // C:\Program Files\Common
  CSIDL_COMMON_DOCUMENTS     = $002E;  // All Users\Documents
  CSIDL_FLAG_CREATE          = $8000;  // new for Win2K, or this in to force creation of folder

  // All Users\Start Menu\Programs\Administrative Tools
  CSIDL_COMMON_ADMINTOOLS    = $002F;
  // <user name>\Start Menu\Programs\Administrative Tools
  CSIDL_ADMINTOOLS           = $0030;
// *)            
