// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Centering the MessageDlg dialog inside a form
//
//        The solution is easy! Just create a procedure local to your form with
//        the same name, MessageDlg.

// Date : 13/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

  {...}

  private
    { Private declarations }
    function MessageDlg(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Integer): Integer;

  {...}

function TForm1.MessageDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Integer): Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      Result := ShowModal
    finally
      Free
    end
end;


