// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Save entire web page as MHT file
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

{ ----------------------------------------------------
  Save Full Internet Explorer pages as MHT

  This is a Delphi conversion of the routine contributed
  by Onega found at :
  http://codeguru.earthweb.com/ieprogram/SaveWholePage.html

  Required units: ADODB_TLB, CDO_TLB
---------------------------------------------------- }

// ----------------------------------------------------
// SaveWholePage -
//   Procedure to save entire web page as MHT file.
//
//   Parameters:
//   AURL - URL for file to be saved
//   AFileName - MHT FileName you want web page saves.
//   AView - Allows you to view the MHT in TWebBrowser
//   AViewer - WebBrowser control to view the page in.
// ----------------------------------------------------
procedure SaveWholePage(AURL: String; AFileName: TFileName; AView: Boolean;
  AViewer: TWebBrowser);
var
  LMsg: IMessage;
  LConf: IConfiguration;
  LFlds: Fields;
  LStrm: _Stream;
begin
  LMsg := CoMessage.Create;
  LConf := CoConfiguration.Create;

  try
    LMsg.Configuration := LConf;
    LMsg.CreateMHTMLBody(AURL, cdoSuppressAll, '', '');
    LStrm := LMsg.GetStream;
    LStrm.SaveToFile(AFileName, adSaveCreateOverWrite);
  finally
    LMsg := nil;
    LConf := nil;
    LStrm := nil;

    if AView then
      AViewer.Navigate(AFileName);
  end;
end;
