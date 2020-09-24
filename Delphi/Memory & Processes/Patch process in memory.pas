// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Patch process in memory
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

{....}

var
  WindowName: Integer;
  ProcessId: Integer;
  ThreadId: Integer;
  buf: PChar;
  HandleWindow: Integer;
  Write: Cardinal;
  
{....}

const
  WindowTitle = 'a program name';  // The program name
  Address = $A662D6;               // Address to patch
  PokeValue = $4A;                 // Value to write
  NumberOfBytes = 2;               // Patch length                
  
{....}


procedure TForm1.Button1Click(Sender: TObject);
begin
  WindowName := FindWindow(nil, WindowTitle);

  if WindowName = 0 then
  begin
    MessageDlg('Program not running.', mtWarning, [mbOK], 0);
  end;

  ThreadId := GetWindowThreadProcessId(WindowName, @ProcessId);
  HandleWindow := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessId);

  GetMem(buf, 1);
  buf^ := Chr(PokeValue);
  WriteProcessMemory(HandleWindow, ptr(Address), buf, NumberOfBytes, Write);
  FreeMem(buf);
  CloseHandle(HandleWindow);
end;

