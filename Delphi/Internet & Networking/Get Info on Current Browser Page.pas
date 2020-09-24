// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Get Info on Current Browser Page
//
//        Get Browser type, Title and URL from current opened browser page
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  DdeMan;

{....}                              

type

  private
    procedure GetBrowserPageInfo(var Browser, Title, URL: string);

{....}

          
// ----------------------------------------------------------------
// Get Browser type, Title and URL from current opened browser page
// ----------------------------------------------------------------
procedure TForm1.GetBrowserPageInfo(var Browser, Title, URL: string);
const
   B: array [0..7] of PChar = ('IExplore', 'Netscape', 'Firefox', 'Opera',
     'Mosaic', 'Netscp6', 'Mozilla', '');
var
   n: Integer;
   Temp: string;
   DdeClientConv: TDdeClientConv;
begin
  DdeClientConv:=TDdeClientConv.Create(self);          
  with DdeClientConv do
    begin
      for n := 0 to Length(B) - 1 do
        if SetLink(B[n], 'WWW_GetWindowInfo') then break;
      Browser := B[n];
      if Browser <> '' then
        begin
          Temp := RequestData('0xFFFFFFFF,sURL,sTitle');
          while Pos('"',Temp) > 0 do
            Delete(Temp,Pos('"',Temp),1);           //Remove the quotes
          URL:=Copy(Temp,1,Pos(',',Temp)-1);                //Get URL
          Title:=Copy(Temp,Pos(',',Temp)+1,Length(Temp));   //Get title
        end
      else
        begin
          URL := '';
          Title := '';
        end;
    end;
  DdeClientConv.Free;
end;


// -----------
// How to use:
// -----------
procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  Browser, Title, URL: string;
begin
  // Retreive informations
  GetBrowserPageInfo(Browser, Title, URL);
  // Display result with labels
  Label1.Caption := Browser;
  Label2.Caption := Title;
  Label3.Caption := URL;
end;


end.
