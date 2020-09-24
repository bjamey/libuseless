// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Fill ListBox with running processes
//
//        Fill ListBox component with running processes names
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ShellAPI, TlHelp32;

{....}

// -----------------------------------------
// Fill ListBox with running processes names
// -----------------------------------------
procedure BuildProcessList;
Var
  recPROCESSENTRY32: PROCESSENTRY32;
  hndSnapShot: DWORD;
  S: String;
  Res: Boolean;
begin
  hndSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  If hndSnapShot <> 0 Then
     Begin
       ListBox1.Clear;
       recPROCESSENTRY32.dwSize := SizeOf(recPROCESSENTRY32);
       Res := Process32First(hndSnapShot, recPROCESSENTRY32);
       While Res <> False Do
         Begin
           S := recPROCESSENTRY32.szExeFile;
           ListBox1.Items.Add(S);
           Res := Process32Next(hndSnapShot, recPROCESSENTRY32);
         End;
       CloseHandle(hndSnapShot);
     End;
end;
