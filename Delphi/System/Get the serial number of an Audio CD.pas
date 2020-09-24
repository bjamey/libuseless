// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get the serial number of an Audio CD
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -------------------------------------------
  How to get the serial number of an Audio CD
  --
  Required units: MMSystem, MPlayer
------------------------------------------- *)

procedure AudioCDSerialNumber(Sender: TObject);
var
   mp : TMediaPlayer;
   msp : TMCI_INFO_PARMS;
   MediaString : array[0..255] of char;
   ret : longint;

begin
     mp := TMediaPlayer.Create(nil);
     mp.Visible := false;
     mp.Parent := Application.MainForm;
     mp.Shareable := true;
     mp.DeviceType := dtCDAudio;
     mp.FileName := 'D:';
     mp.Open;
     Application.ProcessMessages;
FillChar(MediaString, sizeof(MediaString), #0);
FillChar(msp, sizeof(msp), #0);
msp.lpstrReturn := @MediaString;
msp.dwRetSize := 255;
ret := mciSendCommand(Mp.DeviceId,
MCI_INFO,
MCI_INFO_MEDIA_IDENTITY,
longint(@msp));
if Ret <> 0 then
begin
MciGetErrorString(ret, @MediaString, sizeof(MediaString));
Memo1.Lines.Add(StrPas(MediaString));
end
else
Memo1.Lines.Add(StrPas(MediaString));
mp.Close;
Application.ProcessMessages;
mp.free;
end;
