// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Send Command between forms
//
//        How to send message with data (i.e. trackbar pos.) from sender to
//        main form
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

// ------------
// SENDER FORM:
// ------------

uses
  Messages;

const
  const
  WM_MYTRACKBARCHANGE = WM_USER + $600;

{ ... }

implementation;

procedure TSendForm.TrackBarChange(Sender: TObject);
begin
  SendMessage (MainForm.Handle, WM_MYTRACKBARCHANGE, TrackBar.Position, 0);
end;


// ------------
// MAIN FORM:
// ------------

uses
  Messages, SendForm;

{ ... }

private
    procedure WMTrackBarChange (var msg : TMessage); message WM_MYTRACKBARCHANGE;

{ ... }

implementation;

procedure TMainForm.WMTrackBarChange (var msg : TMessage);
var
  RemoteValue: integer;
begin
  RemoteValue := msg.wParam;
  // add here custom code to process RemoteValue
end;

