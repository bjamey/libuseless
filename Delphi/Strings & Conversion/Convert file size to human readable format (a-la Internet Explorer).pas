// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert file size to human readable format (a-la Internet Explorer)
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -----------------------------------------
  Convert file size to human readable
  format (a-la Internet Explorer)

  Use this function to display the "69.1 Kb"
  instead 70846, "1.61 Mb" instead 1697109,
  etc...
----------------------------------------- *)

// API declarations
function StrFormatByteSize(dw: DWORD; szBuf: PChar; uiBufSize: UINT): PChar; stdcall; external 'shlwapi.dll' name 'StrFormatByteSizeA';
function StrFormatKBSize(qdw: LONGLONG; szBuf: PChar; uiBufSize: UINT): PChar; stdcall; external 'shlwapi.dll' name 'StrFormatKBSizeA';

// ---------
// Code
// ---------

// ------------------------------------------------------- //
function Formatted_FileSize(SizeInBytes : Extended) : String;
var
   arrSize: array[0..255] of Char;
begin
     // same formating like in statusbar of Explorer
     StrFormatByteSize(SizeInByte, arrSize, Length(arrSize) - 1);
     Result := Trim(arrSize));
end;
// ------------------------------------------------------- //
function KB_Formatted_FileSize(SizeInKB : Extended) : String;
var
   arrSize: array[0..255] of Char;
begin
     // same formating like in Size column of Explorer in detailed mode
     StrFormatKBSize(SizeInKB, arrSize, Length(arrSize)-1);
     Result := Trim(arrSize));
end;
// ------------------------------------------------------- //
