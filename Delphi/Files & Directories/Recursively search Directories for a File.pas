// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Recursively search Directories for a File
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ----------------------------------------------
   Recursive procedure to build a list of files
---------------------------------------------- *)

procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
   SR: TSearchRec;
   DirList: TStringList;
   IsFound: Boolean;
   i: integer;
begin
     if StartDir[length(StartDir)] <> '\' then StartDir := StartDir + '\';

     // Build a list of the files in directory StartDir

     IsFound := FindFirst(StartDir + FileMask, faAnyFile-faDirectory, SR) = 0;
     while IsFound do
     begin
          FilesList.Add(StartDir + SR.Name);
          IsFound := FindNext(SR) = 0;
     end;
     FindClose(SR);

     // Build a list of subdirectories
     DirList := TStringList.Create;
     IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
     while IsFound do
     begin
          if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
             DirList.Add(StartDir + SR.Name);
          IsFound := FindNext(SR) = 0;
     end;
     FindClose(SR);

     // Scan the list of subdirectories
     for i := 0 to DirList.Count - 1 do
         FindFiles(FilesList, DirList[i], FileMask);

         DirList.Free;
end;

(* -----------------
   Example:
----------------- *)

procedure TForm1.ButtonFindClick(Sender: TObject);
var
   FilesList: TStringList;
begin
     FilesList := TStringList.Create;
     try
        FindFiles(FilesList, EditStartDir.Text, EditFileMask.Text);
        ListBox1.Items.Assign(FilesList);
        LabelCount.Caption := 'Files found: ' + IntToStr(FilesList.Count);
     finally
            FilesList.Free;
     end;
end;
