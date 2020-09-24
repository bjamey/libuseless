// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Get Version Info From File
//
//        Get version info from File, in dotted decimal string format
//
//        GetBuild: BuildInfo parameter:
//
//        biFull:    Release.Major.Minor.Build    1.2.3.782
//        biNoBuild: Release.Major.Minor          1.2.3
//        biCute:    Release.MajorMinor           1.23
//        biRelease: Release                      1
//        biMajor:   Major                        2
//        biMinor:   Minor                        3
//        biBuild:   Build                        782
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


type
  TBuildInfo = (biFull, biNoBuild, biMajor, biMinor, biRelease, biBuild, biCute);


  TMainForm = class(TForm)
    ..
    function GetBuild(const BuildInfo: TBuildInfo): String;


// --------------------------------------------------
// GetBuild
// ---------------------------------------------------
function TForm1.GetBuild(const BuildInfo: TBuildInfo): String;
var 
  dwI, dwJ: dword;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  Result := '';
  dwI := GetFileVersionInfoSize(PChar(Application.ExeName), dwJ);
  if dwI > 0 then 
  begin
    VerInfo := nil;
    try
      GetMem(VerInfo, dwI);
      GetFileVersionInfo(PChar(Application.ExeName), 0, dwI, VerInfo);
      VerQueryValue(VerInfo, '\', Pointer(VerValue), dwJ);
      case BuildInfo of
        biFull: 
          begin
            with VerValue^ do
            begin
              Result := IntToStr(dwFileVersionMS shr 16) + '.';
              Result := Result + IntToStr(dwFileVersionMS and $FFFF) + '.';
              Result := Result + IntToStr(dwFileVersionLS shr 16) + '.';
              Result := Result + IntToStr(dwFileVersionLS and $FFFF);
            end;
          end;
        biNoBuild: 
          begin
            with VerValue^ do
            begin
              Result := IntToStr(dwFileVersionMS shr 16) + '.';
              Result := Result + IntToStr(dwFileVersionMS and $FFFF) + '.';
              Result := Result + IntToStr(dwFileVersionLS shr 16)
            end;
          end;
        biCute: 
          begin
            with VerValue^ do
            begin
              Result := IntToStr(dwFileVersionMS shr 16) + '.';
              Result := Result + IntToStr(dwFileVersionMS and $FFFF);
              Result := Result + IntToStr(dwFileVersionLS shr 16)
            end;
          end;
        biRelease: Result := IntToStr(VerValue^.dwFileVersionMS shr 16);
        biMajor: Result := IntToStr(VerValue^.dwFileVersionMS and $FFFF);
        biMinor: Result := IntToStr(VerValue^.dwFileVersionLS shr 16);
        biBuild: Result := IntToStr(VerValue^.dwFileVersionLS and $FFFF);
      end;
    finally
      FreeMem(VerInfo, dwI);
    end;
  end;
end;
