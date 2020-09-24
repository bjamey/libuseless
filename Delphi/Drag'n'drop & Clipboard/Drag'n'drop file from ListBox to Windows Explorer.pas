// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Drag'n'drop file from ListBox to Windows Explorer
//
//        Drag & drop one file from FileListBox (or other component) to Windows
//        Explorer
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ShlObj, ComObj, ActiveX;

type
  TMainForm = class(TForm, IDropSource)    //  <---- Note This!

{....}

  private
    function  CreateDataObject(const Dir: string; sFile: String): IDataObject;
    // IDropSource methods
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;

{....}

// ---------
// MouseDown
// ---------
procedure TMainForm.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  DataObject: IDataObject;
  Effect: longInt;
begin
  if DragDetect(ListBox1.Handle, POINT(X,Y)) then
    begin
      for i := 0 to ListBox1.Items.Count - 1 do
        if ListBox1.Selected[i] then
          begin
            DataObject := CreateDataObject(ExtractFilePath(ListBox1.Items[i]),
              ExtractFileName(ListBox1.Items[i]));
            break;
          end;
      Effect := DROPEFFECT_NONE;
      DoDragDrop(DataObject, Self, DROPEFFECT_COPY, Effect);
    end;
end;


// ------------
// GiveFeedback
// ------------
function TMainForm.GiveFeedback(dwEffect: Longint): HResult; stdcall;
begin
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;


// -----------------
// QueryContinueDrag
// -----------------
function TMainForm.QueryContinueDrag(fEscapePressed: BOOL;
  grfKeyState: Longint): HResult; stdcall;
begin
  if fEscapePressed or (grfKeyState and MK_RBUTTON = MK_RBUTTON) then
    begin
      Result := DRAGDROP_S_CANCEL
    end
  else if grfKeyState and MK_LBUTTON = 0 then
    begin
      Result := DRAGDROP_S_DROP
    end
  else
    begin
      Result := S_OK;
    end;
end;

     
// -----------------
// Create DataObject
// -----------------
function TMainForm.CreateDataObject(const Dir: string; sFile: String): IDataObject;
var
  Malloc: IMalloc;
  Root: IShellFolder;
  Folder: IShellFolder;
  FilePidl: PItemIDList;
  FolderPidl: PItemIDList;
  chEaten: ULONG;
  dwAttributes: ULONG;
begin
  Result := nil;
  OleCheck(SHGetMalloc(Malloc));
  OleCheck(SHGetDesktopFolder(Root));
  OleCheck(Root.ParseDisplayName(0, nil, PWideChar(WideString(Dir)), chEaten,
    FolderPidl, dwAttributes));
  try
    OleCheck(Root.BindToObject(FolderPidl, nil, IShellFolder, Pointer(Folder)));
    OleCheck(Folder.ParseDisplayName(0, nil, PWideChar(WideString(sFile)),
      chEaten, FilePidl, dwAttributes));
    OleCheck(Folder.GetUIObjectOf(0, 1, FilePidl, IDataObject, nil,
      Pointer(Result)));
  finally
    Malloc.Free(FilePidl);
    Malloc.Free(FolderPidl);
  end;
end;


initialization
  OleInitialize(nil); // initializes the OLE libraries

  
finalization
  OleUninitialize;    // initializes the OLE libraries

