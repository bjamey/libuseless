; -----------------------------------------------------------------------------
;                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
;  Title: Show Systems Disk Space
;
;  Date : 15/05/2007
;  By   : FSL
; -----------------------------------------------------------------------------

// Ali Ebrahimi (ebr_ali@yahoo.com)
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Free1,free2,Total1:Int64;

begin

  GetDiskFreeSpaceEx(pchar(ComboBox1.Text)  , free1 , total1 , @free2);
  Label1.Caption := 'Capacity : ' + IntToStr(Total1) + ' Byte     '+ floatToStr(Total1 div (1024*1024)) + ' MB';
  Label2.Caption := 'Free space : ' + IntToStr(Free1) + ' Byte     '+ floatToStr(Free1 div (1024*1024)) + ' MB';
  Label3.Caption := 'Used space : ' + IntToStr(Total1-Free1) + ' Byte     '+ floatToStr((Total1-Free1) div (1024*1024)) + ' MB';

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  for i:=Ord('A') to Ord('Z') do
    begin
      if  GetDriveType(pchar(char(i)+':\'))=3  then
        ComboBox1.Items.Add(char(i)+':\');
      end;
  ComboBox1.Text:=ComboBox1.Items.Strings[0];
end;

end.
