// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Listing system’s drives in a listbox
//
// Date : 14/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows;  

function GetVolumeName(aRoot: string): string;
var
  VolumeSerialNumber : DWORD;
  MaximumComponentLength : DWORD;
  FileSystemFlags : DWORD;
  VolumeNameBuffer : array[0..255] of char;
begin
  GetVolumeInformation(PChar(aRoot),
                       VolumeNameBuffer,
                       sizeof(VolumeNameBuffer),
                       @VolumeSerialNumber,
                       MaximumComponentLength,
                       FileSystemFlags,
                       nil,
                       0);
  result := string(VolumeNameBuffer);
end; 

function DiskInDrive(aDrive: char): boolean;
var
  vErrMode: word;
begin
  if aDrive in [’a’..’z’] then
    Dec(aDrive, $20);
  if not (aDrive in [’A’..’Z’]) then
    raise Exception.Create(’Not a valid drive letter’);
  vErrMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    result := (DiskSize(Ord(aDrive) - $40) <> -1)
  finally
    SetErrorMode(vErrMode);
  end;
end;                          
                 
procedure TMainForm.FormCreate(Sender: TObject);
var
  drv: char;
begin
  for drv := ’a’ to ’z’ do
    case GetDriveType(PChar(drv + ’:\’)) of
      DRIVE_REMOVABLE, DRIVE_FIXED, DRIVE_CDROM:
        if DiskInDrive(drv) then
          ListBox1.Items.Add(UpperCase(drv) + ’: (’ + GetVolumeName(drv + ’:\’) + ’)’)
        else
          ListBox1.Items.Add(UpperCase(drv) + ’:’);
    end;
end;                 
           
