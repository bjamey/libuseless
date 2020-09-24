// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Get Name and Company from registry
//
//        Get NAME and COMPANY of Windows registration from registry
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Registry;

  {...}

         
procedure GetOwnerAndCompanyName(var sOwner, sOrganization: string);
var
  reg: TRegistry;
  vi: TOSVersionInfo;
  sWindows: string;
begin
  reg      := TRegistry.Create;
  sWindows := '\Windows\';
  try
    vi.dwOSVersionInfoSize := SizeOf(vi);
    getversionex(vi);
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if (vi.dwPlatformId = VER_PLATFORM_WIN32_NT) then sWindows := '\Windows NT\';
    if reg.OpenKey('Software\Microsoft' + sWindows + 'CurrentVersion', False) then
    begin
      // Name
      sOwner := reg.ReadString('RegisteredOwner');
      // Organization
      sOrganization := reg.ReadString('RegisteredOrganization');
    end;
  finally
    reg.Free;
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  sOwner, sOrganization: string;
begin
  GetOwnerAndCompanyName(sOwner, sOrganization);
  Edit1.Text := sOwner;
  Edit2.Text := sOrganization;
end;
