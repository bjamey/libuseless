// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Advanced Directory Selection
//
//        How to browse for folder:
//
//        This code shows the SelectDirectory dialog with additional expansions:
//        - an edit box, where the user can type the path name,
//        - also files can appear in the list,
//        - a button to create new directories.
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ShlObj, ActiveX;

{....}

  private
    function AdvSelectDirectory(const Caption: string; const Root: WideString;
      var Directory: string; EditBox: Boolean = False;
      ShowFiles: Boolean = False; AllowCreateDirs: Boolean = True): Boolean;

{....}

implementation



// -----------------------------------------------------------------------------
// Advanced Directory Selection Dialog
// -----------------------------------------------------------------------------
function MainForm.AdvSelectDirectory(const Caption: string;
  const Root: WideString; var Directory: string; EditBox: Boolean = False;
  ShowFiles: Boolean = False; AllowCreateDirs: Boolean = True): Boolean;

  // ---------------------------------------------------------------------
  // callback function that is called when the dialog has been initialized
  //or a new directory has been selected
  // ---------------------------------------------------------------------
  function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam): Integer;
    stdcall;
  var
    PathName: array[0..MAX_PATH] of Char;
  begin
    case uMsg of
      // This event is called when the dialog has been initialized
      BFFM_INITIALIZED:
        SendMessage(Wnd, BFFM_SETSELECTION, Ord(True), Integer(lpData));

      // This event is called when a new directory has been selected
      BFFM_SELCHANGED:
        begin
          SHGetPathFromIDList(PItemIDList(lParam), @PathName);
          // the directory "PathName" has been selected
        end;
    end;
    Result := 0;
  end;

var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
const
  // necessary for some of the additional expansions
  BIF_USENEWUI = $0040;
  BIF_NOCREATEDIRS = $0200;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      OleInitialize(nil);
      with BrowseInfo do
      begin
        hwndOwner := Application.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        // defines how the dialog will appear:
        ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI or
          BIF_EDITBOX * Ord(EditBox) or BIF_BROWSEINCLUDEFILES * Ord(ShowFiles)
          or BIF_NOCREATEDIRS * Ord(not AllowCreateDirs);
        lpfn := @SelectDirCB;
        if Directory <> '' then
          lParam := Integer(PChar(Directory));
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Calling sample:
// -----------------------------------------------------------------------------
procedure TMainForm.Button1Click(Sender: TObject);
var
  dir: string;
begin
dir := 'c:\';
 if AdvSelectDirectory('Select:' //   W string = Dialog Title
                     , ''        //   W string = Root directory ('' = all)
                     , dir       // R/W string = Selected path
                     , false     //   W   true = Folder Edit Field
                     , false     //   W   true = Show Files
                     , false)    //   W   true = Show "Create Folder" Button
 then
   Label1.Caption := dir
 else
   Label1.Caption := 'Selection cancelled.';
end;

end.
