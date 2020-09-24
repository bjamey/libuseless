// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Detect the movement of a form
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows, Forms;   
  
type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
  public
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
  end; 
  
...  

procedure TForm1.WMMove(var Msg: TWMMove);
begin
  Edit1.Text := IntToStr(Left);
  Edit2.Text := IntToStr(Top);
end;              
