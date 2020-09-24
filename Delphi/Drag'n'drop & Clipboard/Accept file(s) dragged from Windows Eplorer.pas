// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Accept file(s) dragged from Windows Eplorer
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

  uses
    ShellAPI;

{....}

  private
    procedure  WMDropfiles (var msg: Tmessage); message WM_DROPFILES;

{....}

// --------------------------------
// Enable Drop file(s) from windows
// --------------------------------
procedure MainForm.FormCrete(Sender: TObject);
begin
  DragAcceptFiles(MainForm.Handle, True);
end;


// ---------------------------------
// Disable Drop file(s) from windows
// ---------------------------------
procedure MainForm.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(MainForm.Handle, False);
end;


// ----------------------------
// Drop file(s) handle routines
// ----------------------------
procedure TMainForm.WMDropfiles (var msg: Tmessage);
var
  hdrop: Integer;     //THandle
  Buffer: String;
  buflength: Integer;
  NumFiles : longint;
  i : longint;
begin
  hdrop := msg.WParam;
  // How many files are being dropped
  NumFiles := DragQueryFile(hdrop, $FFFFFFFF, nil, 0);
  // Accept the dropped files
  for i := 0 to (NumFiles - 1) do
    begin
      buflength := DragQueryFile(hdrop, i, nil, 300) + 1;
      setlength(Buffer, buflength);
      DragQueryFile(hdrop, i, PChar(Buffer), buflength);
      Buffer := Trim(Buffer);
      // add file path and name to TMemo
      Memo1.Lines.Add(Buffer);
    end;
  DragFinish(hdrop);
end;
