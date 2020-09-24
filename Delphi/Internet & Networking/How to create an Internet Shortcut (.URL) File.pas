// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: How to create an Internet Shortcut (.URL) file
//
// File "FSL Home Page.URL" Example:
//
//      [InternetShortcut]
//      URL=http://fsl.sytes.net
//
// As you can see, .URL files have an INI file format.
// The URL represents the address location of the page to load.
// It must specify a fully qualifying URL.
//
// Date : 26/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


uses IniFiles;

{ ... }

// Create ShortCut procedure

procedure CreateInternetShortcut(const FileName, LocationURL : string);
begin
  with TIniFile.Create(FileName) do
  try
    WriteString('InternetShortcut', 'URL', LocationURL);
  finally
    Free;
  end;
end;


// Sample Usage:
//
// Create an .URL file named "FSL Home Page", in the root folder of the C drive,
// let it point to http://fsl.sytes.net .

CreateInterentShortcut('c:\FSL Home Page.URL ', 'http://fsl.sytes.net ');
                            
