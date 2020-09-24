// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get and Set Audio Volume
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit uMain;

interface

uses
 Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
 ExtCtrls,StdCtrls, mmsystem;  //You must add this in the uses line

type
 TForm1 = class(TForm)
   procedure FormCreate(Sender: TObject);
   procedure FormClose(Sender: TObject; var Action: TCloseAction);
 private
   { Private declarations }
 public
    myvolume: array[0..10] of longint;
   { Public declarations }
 end;

var
 Form1: TForm1;

implementation

{$R *.DFM}
// ------------------------------------------------------- //
procedure TForm1.FormCreate(Sender: TObject);
var
   Count, i: integer;
begin
     Count := auxGetNumDevs;

     for i := 0 to Count do
     begin
          // The i is the device: i.e. 0 = Wav Volume
          auxgetvolume(i, addr(myvolume[i]));    // Gets the values that the user has set

          // The reason for the 9000*65536 + 9000 is if you wanted to do left and right channels
          auxsetvolume(i, longint(9000) * 65536 + longint(9000));  // Sets the volume very very low
     end;
end;
// ------------------------------------------------------- //
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
   Count, i: integer;
begin
     Count := auxGetNumDevs;

     for i := 0 to Count do
     begin
          auxsetvolume(i, myvolume[i]); // Sets the volume back to the users old settings
     end;
end;
// ------------------------------------------------------- //
end.
