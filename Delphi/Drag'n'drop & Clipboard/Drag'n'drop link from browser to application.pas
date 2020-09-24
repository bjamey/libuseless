// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Drag'n'drop link from browser to application
//
//        OLE Drop: drop links from browser to application
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ComObj, ActiveX;

{....}

type
  TMainForm = class(TForm, IDropTarget) // <-- Note this!

{....}

private
    // IDropTarget methods
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;

{....}

implementation

var
  // Custom OLE Clipboard formats
  CF_HTMLFORMAT: DWORD;
  CF_URL: DWORD;
  CF_NETSCAPEBOOKMARK: DWORD;
  CF_FILEGROUPDESCRIPTOR: DWORD;


// -----------_____________________________
// FORM CREATE
// -----------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  // initializes the OLE libraries
  OleInitialize(nil);

  // Register custom formats for OLE clipboard and drag/drop. The others
  // (CF_TEXT, CF_BITMAP, CF_DIB) are built in and don't need to be registered

  // HTML format, passed from IE
  CF_HTMLFORMAT := RegisterClipboardFormat('HTML Format');
  // URLs, passed from IE
  CF_URL := RegisterClipboardFormat('UniformResourceLocator');
  // URLs, passed from Netscape
  CF_NETSCAPEBOOKMARK := RegisterClipboardFormat('Netscape Bookmark');
  // URL titles are passed in a file group descriptor
  CF_FILEGROUPDESCRIPTOR := RegisterClipboardFormat('FileGroupDescriptor');

  // Allow Panel1 to accept drop events
  OleCheck(RegisterDragDrop(Panel1.Handle, Self));
end;

// ------------ _____________________________
// FORM DESTROY
// ------------
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // Stop Panel1 to accept drop events
  OleCheck(RevokeDragDrop(Panel1.Handle));
end;


// -----------------------------------------------------------------------------
// IDropTarget - Implementations
// -----------------------------------------------------------------------------

// ----------------------_____________________________
// IDropTarget: Drag over
// ----------------------
function TMainForm.DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
  pt: TPoint; var dwEffect: Longint): HResult;
begin
  dwEffect := DROPEFFECT_LINK;
  Result := NOERROR;
end;

// ----------------------_____________________________
// IDropTarget: Drag over
// ----------------------
function TMainForm.DragOver(grfKeyState: Longint; pt: TPoint;
  var dwEffect: Longint): HResult;
begin
  dwEffect := DROPEFFECT_LINK;
  Result := NOERROR;
end;

// -----------------------______
// IDropTarget: Drag Leave
// -----------------------
function TMainForm.DragLeave: HResult;
begin
  Result := NOERROR;
end;

// -----------------____________
// IDropTarget: Drop
// -----------------
function TMainForm.Drop(const dataObj: IDataObject; grfKeyState: Longint;
  pt: TPoint; var dwEffect: Longint): HResult;
var
  aFormatEtc: TFORMATETC;
  aStgMedium, newStgMedium: TSTGMEDIUM;
  pData: PChar;
  aPos: integer;
  URLTitle, URLLink: string;
begin
  if (dataObj = nil) then  //Make certain the data is available
    begin
      dwEffect := DROPEFFECT_NONE;
      result := E_FAIL;
      exit;
    end;

  aFormatEtc.dwAspect := DVASPECT_CONTENT;
  aFormatEtc.ptd := nil;
  aFormatEtc.lindex := -1;
  
  aFormatEtc.cfFormat := CF_URL;
  aFormatEtc.tymed := TYMED_HGLOBAL;
  result := dataObj.GetData(aFormatEtc, aStgMedium);

  if Failed(result) then
  begin
    aFormatEtc.cfFormat := CF_NETSCAPEBOOKMARK;
    aFormatEtc.tymed := TYMED_HGLOBAL;
    result := dataObj.GetData(aFormatEtc, aStgMedium);
  end;

  if Failed(result) then
  begin
    aFormatEtc.cfFormat := CF_HTMLFORMAT;
    aFormatEtc.tymed := TYMED_HGLOBAL;
    result := dataObj.getData(aFormatEtc, aStgMedium);
  end;

  // If that wasn't successful, notify that no drop was done
  if Failed(result) then
    dwEffect := DROPEFFECT_NONE
  else
    begin
      // Get the URL text
      try
        // Lock the global memory handle to get a pointer to the data
        pData := GlobalLock(aStgMedium.hGlobal);
        URLLink := pData;                         // Get Text
      finally
        GlobalUnlock(aStgMedium.hGlobal);         //Finished with the pointer
        ReleaseStgMedium(aStgMedium);             //Free the memory
      end;

      // If URL have title... get title from file group descriptor
      if (aFormatEtc.cfFormat = CF_URL)
      or (aFormatEtc.cfFormat = CF_NETSCAPEBOOKMARK) then
        begin
          aFormatEtc.cfFormat := CF_FILEGROUPDESCRIPTOR;
          aFormatEtc.dwAspect := DVASPECT_CONTENT;
          aFormatEtc.tymed := TYMED_HGLOBAL;
          aFormatEtc.ptd := nil;
          aFormatEtc.lindex := -1;
          // Get data
          result := dataObj.GetData(aFormatEtc, newStgMedium);
          // If we got it, tell the owner and release the storage medium
          if not FAILED(result) then
            begin
              // Get the URL title
              try
                pData := GlobalLock(newStgMedium.hGlobal);
                // The title appears at offset 76...
                SetString(URLTitle, pData+76, strLen(pData+76));
                // The string has ".url" appended.  Cut it off.
                aPos := pos('.URL', UpperCase(URLTitle));
                if (aPos > 0) then
                  Delete(URLTitle, aPos, 4);
                // Netscape prepends "Shortcut to " to the title before making
                // it available.  Cut it off.
                if (aFormatEtc.cfFormat = CF_NETSCAPEBOOKMARK) then
                begin
                  aPos := pos('SHORTCUT TO ', UpperCase(URLTitle));
                  if (aPos > 0) then
                    Delete(URLTitle, aPos, 12);
                end;
              finally
                GlobalUnlock(newStgMedium.hGlobal); // Release the data
                ReleaseStgMedium(newStgMedium);     // Release storage medium
              end
            end;
        end;

      Label1.Caption := URLTitle;
      Label2.Caption := URLLink;

      Result := NOERROR;
    end;
end;

end.
