// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
//
// Title: Drag'n'drop file(s) from FileListBox to Windows Explorer
//
//        Drag & drop one or more files from FileListBox (or other string list
//        component) to Windows Explorer.
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
    function  CreateDataObject(const Dir: string; Files: TStrings): IDataObject;
    // IDropSource methods
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;

{....}             

// ---------
// MouseDown
// ---------
procedure TMainForm.FileListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelFileList: TStrings;
  i: Integer;
  DataObject: IDataObject;
  Effect: longInt;
begin
  if DragDetect(FileListBox1.Handle, POINT(X,Y)) then
    begin
      SelFileList := TStringList.Create;
      try
        SelFileList.Capacity := FileListBox1.SelCount;
        for i := 0 to FileListBox1.Items.Count - 1 do
          if FileListBox1.Selected[i] then
            SelFileList.Add(FileListBox1.Items[i]);
        DataObject := CreateDataObject(FileListBox1.Directory, SelFileList);
      finally
        SelFileList.Free;
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
function TMainForm.CreateDataObject(const Dir: string;
  Files: TStrings): IDataObject;
type
  PArrayOfPItemIDList = ^TArrayOfPItemIDList;
  TArrayOfPItemIDList = array[0..0] of PItemIDList;
var
  Malloc: IMalloc;
  Root: IShellFolder;
  FolderPidl: PItemIDList;
  Folder: IShellFolder;
  p: PArrayOfPItemIDList;
  chEaten: ULONG;
  dwAttributes: ULONG;
  FileCount: Integer;
  i: Integer;
begin
  Result := nil;
  if Files.Count = 0 then
    Exit;
  OleCheck(SHGetMalloc(Malloc));
  OleCheck(SHGetDesktopFolder(Root));
  OleCheck(Root.ParseDisplayName(0, nil, PWideChar(WideString(Dir)), chEaten,
    FolderPidl, dwAttributes));
  try
    OleCheck(Root.BindToObject(FolderPidl, nil, IShellFolder, Pointer(Folder)));
    FileCount := Files.Count;
    p := AllocMem(SizeOf(PItemIDList) * FileCount);
    try
      for i := 0 to FileCount - 1 do
        begin
          OleCheck(Folder.ParseDisplayName(0, nil,
            PWideChar(WideString(Files[i])), chEaten, p^[i], dwAttributes));
        end;
      OleCheck(Folder.GetUIObjectOf(0, FileCount, p^[0], IDataObject, nil,
        Pointer(Result)));
    finally
      for i := 0 to FileCount - 1 do
        begin
          if p^[i] <> nil then Malloc.Free(p^[i]);
        end;
      FreeMem(p);
    end;
  finally
    Malloc.Free(FolderPidl);
  end;
end;


initialization
  OleInitialize(nil); // initializes the OLE libraries

    
finalization
  OleUninitialize;    // initializes the OLE libraries

