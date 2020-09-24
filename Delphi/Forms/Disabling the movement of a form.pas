// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Disabling the movement of a form
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

uses
  Windows, Forms; 

type
  TForm1 = class(TForm)
  public
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
  end; 
  
...    

procedure TForm1.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  with Msg do
    if Result = HTCAPTION then Result := HTNOWHERE;
end;                   
