// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Customized tooltips
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

...     

type
  TMyHintWindow = class(THintWindow)
    constructor Create(AOwner: TComponent); override;
  end;

...  

constructor TMyHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Canvas.Font.Name := ’Arial’;
  Canvas.Font.Size := 14;
end;       

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.ShowHint := false;
  HintWindowClass := TMyHintWindow;
  Application.ShowHint := true;
end;                 
