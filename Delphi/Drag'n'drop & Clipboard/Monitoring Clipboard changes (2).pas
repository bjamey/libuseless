// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Monitoring Clipboard changes
//
//        An application can be notified of changes in the data stored in the
//        Windows clipboard by registering itself as a Clipboard Viewer.
//
//        Clipboard viewers use two API calls and several messages to
//        communicate with the Clipboard viewer chain. SetClipboardViewer adds
//        a window to the beginning of the chain and returns a handle to the
//        next viewer in the chain.
//        ChangeClipboardChain removes a window from the chain. When a clipboard
//        change occurs, the first window in the clipboard viewer chain is
//        notified via the WM_DrawClipboard message and must pass the message on
//        to the next window.
//        To do this, our application must store the next window along in the
//        chain to forward messages to and also respond to the WM_ChangeCBChain
//        message which is sent whenever any other clipboard viewer on the
//        system is added or removed to ensure the next window along is valid.
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ClipBrd;

{....}

  private
    FNextClipboardViewer: HWND;
    procedure WMChangeCBChain(var Msg : TWMChangeCBChain); message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Msg : TWMDrawClipboard); message WM_DRAWCLIPBOARD;

{....}

// ----------------------
// Add to clipboard chain
// ----------------------
procedure TForm1.FormCreate(Sender : TObject);
begin
  FNextClipboardViewer := SetClipboardViewer(Handle);
end;


// ---------------------------
// Remove from clipboard chain
// ---------------------------
procedure TForm1.FormDestroy(Sender : TObject);
begin
  ChangeClipboardChain(Handle, FNextClipboardViewer);
end;


// ---------------------
// The chain has changed
// ---------------------
procedure TForm1.WMChangeCBChain(var Msg : TWMChangeCBChain);
begin
  inherited;
  // mark message as done
  Msg.Result := 0;
  // the chain has changed
  if Msg.Remove = FNextClipboardViewer then
    // The next window in the clipboard viewer chain had been removed.
    // We recreate it.
    FNextClipboardViewer := Msg.Next
  else
    // Inform the next window in the clipboard viewer chain
    SendMessage(FNextClipboardViewer, WM_CHANGECBCHAIN, Msg.Remove, Msg.Next);
end;


// ---------------------------------
// The Clipboard content has changed
// ---------------------------------
procedure TForm1.WMDrawClipboard(var Msg : TWMDrawClipboard);
begin
  inherited;
  try
    // If Clipboard contain text, add text to TMemo
    if Clipboard.HasFormat(CF_TEXT) then
      Memo1.Lines.Add(Clipboard.AsText);
  finally
    // Inform the next window in the clipboard viewer chain
    SendMessage(FNextClipboardViewer, WM_DRAWCLIPBOARD, 0, 0);
  end;

end;


