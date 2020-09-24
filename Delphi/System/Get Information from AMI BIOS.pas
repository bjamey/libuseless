// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to get Information from AMI BIOS
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -----------------------------------------------

   This code will only work on recent ami bios
   computers
   The memory addresses that BIOS info is stored
   at will change according to different BIOS
   manufactures, different versions of BIOS and
   different computers.
----------------------------------------------- *)

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    Edit1: TEdit;
    Label5: TLabel;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

// ------------------------------------------- //
function HexToInt (s: string): Integer;
const
     Hex : array ['A'..'F'] of Integer = (10,11,12,13,14,15);
var
   i : Integer;
begin
    Result := 0;
    s := UpperCase (s);

    for i := 1 to Length (s) do
    begin
         if s [i] < 'A' then
            Result := Result * 16 + Ord (s [i]) - 48
         else
             Result := Result * 16 + Hex [s [i]];
    end;
end;
// ------------------------------------------- //
procedure TForm1.Button1Click(Sender: TObject);
var
   Scan, Copyright, Info, Date : string;
   Data : Integer;
const
     BiosCopyright = $FE0CB; {Good address for AMI BIOS only}
     BiosInfo      = $FF478; {Good address for AMI BIOS only}
     BiosDate      = $FFFF5; {Good address for AMI BIOS only}
begin
    Data :=(HexToInt(Edit1.Text)); {Convert to Integer}
    Scan := (PChar(Ptr(Data)));    {Get info for inputted memory address}
    Copyright := string (PChar (Ptr (BiosCopyright)));{The same as a debug -d F000:E0CB}
    Info := string (PChar (Ptr (BiosInfo)));{The same as a debug -d F000:F478}
    Date := string (PChar (Ptr (BiosDate)));{The same as a debug -d F000:FFF5}

    label1.caption := Scan;
    label2.caption := Date;
    label3.caption := Info;
    label4.caption := Copyright;
    label5.caption := (IntToStr(Data));{Display memory address in decimal}
end;
// ------------------------------------------- //
end.
