// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get Executable Full Name From Window Handle
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* --------------------------------------------
   Get Executable Full Name From Window Handle
   --
   Required unit: Tlhelp32
-------------------------------------------- *)

function GetExeNameFromWindowHandle(AParent : HWND) : String;
var
   ProcessEntry32 : TProcessEntry32;
   ProcessId      : DWord;
   SnapshotHandle : Integer;
begin
     Result := '';

     // Get the identifier of the thread that created the specified window AParent
     GetWindowThreadProcessId(AParent, @ProcessId);

     // take a snapshot of the processes and the heaps, modules, and threads used by the processes
     SnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
     try
        ProcessEntry32.dwSize := SizeOf(TProcessEntry32);

        // verify a proces is in the snapshot
        if Process32First(SnapshotHandle,ProcessEntry32) then
        begin
             { loop through all the processes in the snapshot until we match the
             process is with the one retrieved using GetWindowThreadProcessId()
             above }
             repeat
                   if ProcessEntry32.th32ProcessID = ProcessId then
                   begin
                        Result := StrPas(ProcessEntry32.szExeFile);
                        Break;
                   end;

             { repeat until there are no more processes in the snapshot }
             until Not(Process32Next(SnapshotHandle,ProcessEntry32));
        end;
     finally
            Windows.CloseHandle(SnapshotHandle);
     end;
end;
