// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Undocumented MessageBoxTimeOut function
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -----------------------------------------
   Undocumented MessageBoxTimeOut function

   How to create a message box and auto
   close it after a certain x seconds
----------------------------------------- *)
unit MsgBoxTimeOut;

interface

uses Windows;

const
     MB_TIMEDOUT = 32000;

function MessageBoxTimeOut(hWnd: HWND; lpText: PChar; lpCaption: PChar;
                           uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall;

function MessageBoxTimeOutA(hWnd: HWND; lpText: PChar; lpCaption: PChar;
                           uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall;

function MessageBoxTimeOutW(hWnd: HWND; lpText: PWideChar; lpCaption: PWideChar;
                           uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall;

implementation
     function MessageBoxTimeOut; external user32 name 'MessageBoxTimeoutA';
     function MessageBoxTimeOutA; external user32 name 'MessageBoxTimeoutA';
     function MessageBoxTimeOutW; external user32 name 'MessageBoxTimeoutW';
end.

// -------
// Usage:
// -------

// uses  ..., MsgBoxTimeout;


procedure TForm1.Button1Click(Sender: TObject);
var
   iRet: Integer;
   iFlags: Integer;
begin
     iFlags := MB_OK or MB_SETFOREGROUND or MB_SYSTEMMODAL or MB_ICONINFORMATION;
     iRet   := MessageBoxTimeout(Application.Handle, 'Test a timeout of 2 seconds.',
                            'MessageBoxTimeout Test', iFlags, 0, 2000);
     // Here, iRet will be = 1 (IDOK)

     ShowMessage(IntToStr(iRet));

     iFlags := MB_YESNO or MB_SETFOREGROUND or MB_SYSTEMMODAL or MB_ICONINFORMATION;
     iRet   := MessageBoxTimeout(Application.Handle, 'Test a timeout of 5 seconds.',
                             'MessageBoxTimeout Test', iFlags, 0, 5000);
     // iRet = MB_TIMEDOUT if no buttons clicked, otherwise
     // iRet will return the value of the button clicked

     case iRet of
        IDYES:  // Pressed Yes button
           ShowMessage('Yes');
        IDNO:  // Pressed the No button
           ShowMessage('No');
        MB_TIMEDOUT: // MessageBox timed out
           ShowMessage('TimedOut');
     end;
end;
