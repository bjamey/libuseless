// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Disable Ctrl + Alt + Del (Task Manager) under 2000 and XP
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// ----------------------------------
// Disable Ctrl + Alt + Del
// (Task Manager) under Windows 2000
// and XP
// ----------------------------------

unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TlHelp32, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   Form1: TForm1;
   proc : PROCESSENTRY32;
   hSnap : HWND;
   Looper : BOOL;

implementation

// ------------------------------------------- //
procedure KillProcess;
begin
     // Give Proc.dwSize The Size Of Its Bytes
     proc.dwSize := SizeOf(Proc);

     //Takes A Snapshop Of The Process And Give It To hSnap
     hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

     // First Process
     Looper := Process32First(hSnap,proc);

     while Integer(Looper) <> 0 do            // If The Process is not nil
     begin
          // Extracts the process filename and compares
          if ExtractFileName(Proc.szExeFile) = 'taskmgr.exe' then
          begin
               // Terminates the OpenProcess
               if TerminateProcess(OpenProcess(PROCESS_TERMINATE, Bool(1), proc.th32ProcessID), 0) then
                  //
               else
                   // Checks for the next process
                   Looper := Process32Next(hSnap, proc);
          end;
     end;

     // Closes The Handle
     CloseHandle(hSnap);
end;
// ------------------------------------------- //

{$R *.dfm}

// ------------------------------------------- //
procedure TForm1.Timer1Timer(Sender: TObject);
var
   keyloop, KeyResult : Integer;
begin
     keyloop := 0;

     repeat
           KeyResult := GetAsyncKeyState(keyloop);
           if KeyResult = -32767 then
           begin
                if (keyloop = 46) or (keyloop = 110) then KillProcess;
           end;

           Inc(keyloop);
     until keyloop = 255;
end;
// ------------------------------------------- //
end.
