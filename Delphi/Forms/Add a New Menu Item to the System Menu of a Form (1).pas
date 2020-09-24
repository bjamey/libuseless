// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Add a New Menu Item to the System Menu of an Application
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit sysmenu;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes,
  Graphics, Controls, Forms, Dialogs, Menus;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
     {This declaration is of the type TMessageEvent which
      is a pointer to a procedure that takes two variable
      arguments of type TMsg and Boolean, respectively}

     procedure WinMsgHandler(var Msg : TMsg;
                             var Handled : Boolean);
  end;

var
  Form1: TForm1;

const
  MyItem = 100; {Here's the menu identifier.
                 It can be any WORD value}

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin

  {First, tell the application that its message
  handler is different from the default}
  Application.OnMessage := WinMsgHandler;

  {Add a separator}
  AppendMenu(GetSystemMenu(Self.Handle, False),
           MF_SEPARATOR, 0, '');

  {Add your menu choice. Since the Item ID is high,
  using the MF_BYPOSITION constant will place
   it last on the system menu}
  AppendMenu(GetSystemMenu(Self.Handle, False),
             MF_BYPOSITION, MyItem, 'My Men&u Choice');

end;


procedure TForm1.WinMsgHandler(var Msg : TMsg;
                          var Handled : Boolean);
begin
{if the message is a system one...}
  if Msg.Message=WM_SYSCOMMAND then
   if Msg.wParam = MyItem then
     {Put handling code here. I've opted for
      a ShowMessage for demonstration purposes}
     ShowMessage('You picked my menu!!!');
end;
