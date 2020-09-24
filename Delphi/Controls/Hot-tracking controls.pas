// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Hot-tracking controls
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

// The purpose is to highlight the control which receives the focus.
// First method:

type
  TMyEdit = class(TEdit)  
protected
  procedure DoEnter; override;
  procedure DoExit; override;
end; 

...   

procedure TMyEdit.DoEnter;
begin
  Color := clAqua;
  inherited;        
end;
procedure TMyEdit.DoExit;
begin
  Color := clWindow;
  inherited;
end;               
        
//Second method:

type
  TMyLabel = class(TLabel)
protected
  procedure WndProc(var AMessage : TMessage); override;
end; 

...  

procedure TMyLabel.WndProc(var AMessage: TMessage);
begin
  if (AMessage.Msg = CM_MOUSEENTER) then
    Color := clAqua
  else if (AMessage.Msg = CM_MOUSELEAVE) then
    Color := clWindow;
  inherited;        
end;                          
