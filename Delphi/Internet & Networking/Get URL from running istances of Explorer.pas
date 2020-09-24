// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Get URL from running istances of Explorer
//
//        To have the locationurls from all running instances of Internet
//        Explorer - including open folders and Windows Explorer - shown in a
//        listbox.
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  SHDocVw;

{....}

procedure TForm1.Button1Click(Sender: TObject);
var
  x: Integer;
  Sw: IShellWindows;
begin
  sw := CoShellWindows.Create;
  for x := 0 to SW.Count - 1 do
    Listbox1.Items.Add((Sw.Item(x) as IWebbrowser2).LocationUrl);
end;

                  
