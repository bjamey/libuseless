// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
//
// Title: Send data between applications
//
// Date : 14/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// -----------------------------------------------
// SENDER Application
// -----------------------------------------------

procedure TSenderMainForm.SendData;
var
  res: integer;
  cmdToSend: integer
  dataToSend: string;
  receiverHandle: THandle;
  copyDataStruct: TCopyDataStruct;    // Declared in Windows.pas

begin
  cmdToSend := $C6;      // any command value... to identify the data contents
  dataToSend := 'This is a string sended to other application';

  copyDataStruct.dwData := cmdToSend;
  copyDataStruct.cbData := 1 + Length(dataToSend);
  copyDataStruct.lpData := PChar(dataToSend);

  receiverHandle := FindWindow(PChar('TReceiverMainForm'),PChar('ReceiverMainForm'));
  if receiverHandle = 0 then
  begin
    ShowMessage('Receiver application NOT found!');
    Exit;
  end;
  res := SendMessage(receiverHandle, WM_COPYDATA, Integer(Handle), Integer(@copyDataStruct));
  if res <> 1 then
    ShowMessage('Data NOT received!');
end;


// -----------------------------------------------
// RECEIVER Application
// -----------------------------------------------

  private
    procedure WMCopyData(var Msg : TWMCopyData); message WM_COPYDATA;

{ ... }

implementation;


procedure TReceiverMainForm.WMCopyData(var Msg: TWMCopyData);    
var
  receivedData: string;
  receivedCmd: integer;

begin
  receivedCmd := Msg.CopyDataStruct.dwDat);            // received command
  receivedData := PChar(Msg.CopyDataStruct.lpData);    // received data

  //Send something back
  msg.Result := 1;
end;

