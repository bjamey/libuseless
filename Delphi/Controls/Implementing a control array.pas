// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Implementing a control array
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

...

const
  Count = 5; 
  
type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  public
    Edits: array[0..Count-1] of TEdit;
    procedure EditChange(Sender: TObject);
  end;  
  
...     

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Count-1 do
  begin
    Edits[i] := TEdit.Create(Self);
    with Edits[i] do
    begin
      Parent := Self;
      SetBounds(10, 10 + i*50, 200, 40);
      Tag := i; //each control should remember its index
      OnChange := EditChange; //same event handler for all controls
    end;
  end;
end;

procedure TForm1.EditChange(Sender: TObject);
var
  i: integer;
begin
  i := TEdit(Sender).Tag;
  ShowMessage(IntToStr(i));
end;       
