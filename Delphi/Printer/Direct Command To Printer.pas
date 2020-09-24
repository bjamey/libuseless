// ----------------------------------------------------------------------------
//                                      DTT 1.1.5.0  (c)2006 FSL - FreeSoftLand
// Title: Direct Command To Printer - Passthrough/Escape
//
// Date : 08.8.2006
// By   : Dimitar Minchev <mitko@bfu.bg>
// ----------------------------------------------------------------------------

unit Esc1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    // Private declarations
  public
    // Public declarations
  end;

var
  Form1: TForm1;

implementation

// Add the printers unit
uses Printers;

{$R *.DFM}

// declare the PASSTHROUGH structure
type TPrnBuffRec = record
  BuffLength : word;
  Buffer : array [0..255] of char;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  Buff : TPrnBuffRec;
  TestInt : integer;
  s : string;
begin

  // Test to see if the PASSTHROUGH escape is supported
  TestInt := PASSTHROUGH;
  if Escape(Printer.Handle,
            QUERYESCSUPPORT,
            sizeof(TestInt),
            @TestInt,
            nil) > 0 then begin

    // Start the printout
    Printer.BeginDoc;

    // Make a string to passthrough
    s := ' A Test String ';

    // Copy the string to the buffer
    StrPCopy(Buff.Buffer, s);

    // Set the buffer length
    Buff.BuffLength := StrLen(Buff.Buffer);

    // Make the escape
    Escape(Printer.Canvas.Handle, PASSTHROUGH, 0, @Buff, nil);

    // End the printout
    Printer.EndDoc;
  end;
end;

end.
