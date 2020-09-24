// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Add checkboxes to a TShellTreeView
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ---------------------------------
  Add checkboxes to a TShellTreeView
  --
  Author: OverZone Software
---------------------------------- *)

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellCtrls;

type
  TCheckBoxShellTreeView = class(ShellCtrls.TShellTreeView)
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ShellTreeView: TCheckBoxShellTreeView;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

const
     TVS_CHECKBOXES = $00000100;

{$R *.dfm}
//------------------------------------------------------------------------//
procedure TForm1.FormCreate(Sender: TObject);
begin
     ShellTreeView := TCheckBoxShellTreeView.Create(Self);
     with ShellTreeView do
     begin
          Name := 'ShellTreeView';
          Parent := Self;
          Root := 'rfDesktop';
          UseShellImages := True;
          Align := alClient;
          AutoRefresh := False;
          BorderStyle := bsNone;
          Indent := 19;
          ParentColor := False;
          RightClickSelect := True;
          ShowRoot := False;
          TabOrder := 0;
     end;
end;
//------------------------------------------------------------------------//
procedure TCheckBoxShellTreeView.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.Style := Params.Style or TVS_CHECKBOXES;
end;
//------------------------------------------------------------------------//
end.
