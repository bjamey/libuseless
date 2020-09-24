// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Fade Forms on Closing
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit Fade;

//Fading Form - 100 lines
//Comboy
//August 24, 2003
//Planet Source Code
//Comboy@usa.com

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ComCtrls, ExtCtrls;//be sure to use XPman so the panel color doesn't make any problems after changing form color

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    RadioButton1: TRadioButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    TrackBar1: TTrackBar;
    ColorDialog1: TColorDialog;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
Form1.AlphaBlend := True;
TrackBar1.Max := 255;//max alphablendvalue is 255
TrackBar1.Min := 55; //min alphablendvalue isn't 55!
TrackBar1.Frequency := 5;
TrackBar1.Position := 255;//form looks like a simple window
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
while Form1.AlphaBlendValue > 1 do
{Don't set the alphablendvalue to 0, because in win 9x the form doesn't
fade and if you set it to 0, it will suddenly disappear!}
begin
Form1.AlphaBlendValue := Form1.AlphaBlendValue - 1;{if you want to make it faster don't
use a greater number after "-" use the sleep function instead}
Sleep(20);// Change the sleep time to manage fading speed
end;
MessageDlg ('Don''t Forget to Rate this code!', MTWarning, [MBOK], 0);
//Pliz, reit dis cod
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
Form1.AlphaBlendValue := TrackBar1.Position;
//See, trackbar1.min is 55 - it's never 0
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if Button1.Caption='Fullscreen' then
begin
//Fullscreening form
BorderStyle := BSNone;
WindowState := WSMaximized;
Height := Screen.Height;
Width := Screen.Width;
FormStyle := FSStayOnTop;//you can remove this line
Button1.Caption := 'Close';
//Centerizing stuff
Panel1.Left := 280;
Panel1.Top := 160;
end
else
Close;//Don't use anything else, just "close"
end;

procedure TForm1.Label4Click(Sender: TObject);
begin
ColorDialog1.Execute;
Form1.Color:=ColorDialog1.Color;
end;
end.
