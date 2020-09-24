// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Scan Remote TCP Ports
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(******************************************************************************
 ******************************************************************************
 ***                                                                        ***
 ***   FastScan (multi threaded TCP port scanner)                           ***
 ***   Version [1.10d]                              {Last mod 2003-08-15}   ***
 ***                                                                        ***
 ******************************************************************************
 ******************************************************************************

                                 _\\|//_
                                (` * * ')
 ______________________________ooO_(_)_Ooo_____________________________________
 ******************************************************************************
 ******************************************************************************
 ***                                                                        ***
 ***                Copyright (c) 1995 - 2003 by -=Assarbad=-               ***
 ***                                                                        ***
 ***   CONTACT TO THE AUTHOR(S):                                            ***
 ***    ____________________________________                                ***
 ***   |                                    |                               ***
 ***   | -=Assarbad=- aka Oliver            |                               ***
 ***   |____________________________________|                               ***
 ***   |                                    |                               ***
 ***   | Assarbad@gmx.info|.net|.com|.de    |                               ***
 ***   | ICQ: 281645                        |                               ***
 ***   | AIM: nixlosheute                   |                               ***
 ***   |      nixahnungnicht                |                               ***
 ***   | MSN: Assarbad@ePost.de             |                               ***
 ***   | YIM: sherlock_holmes_and_dr_watson |                               ***
 ***   |____________________________________|                               ***
 ***             ___                                                        ***
 ***            /   |                     ||              ||                ***
 ***           / _  |   ________ ___  ____||__    ___   __||                ***
 ***          / /_\ |  / __/ __//   |/  _/|   \  /   | /   |                ***
 ***         / ___  |__\\__\\  / /\ || |  | /\ \/ /\ |/ /\ | DOT NET        ***
 ***        /_/   \_/___/___/ /_____\|_|  |____/_____\\__/\|                ***
 ***       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        ***
 ***              [http://assarbad.net | http://assarbad.org]               ***
 ***                                                                        ***
 ***   Notes:                                                               ***
 ***   - my first name is Oliver, you may well use this in your e-mails     ***
 ***   - for questions and/or proposals drop me a mail or instant message   ***
 ***                                                                        ***
 ***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~***
 ***              May the source be with you, stranger ... ;)               ***
 ***    Snizhok, eto ne tolko fruktovij kefir, snizhok, eto stil zhizn.     ***
 ***                     Vsem Privet iz Germanij                            ***
 ***                                                                        ***
 *** Greets from -=Assarbad=- fly to YOU =)                                 ***
 *** Special greets fly 2 Nico, Casper, SA, Pizza, Navarion, Eugen, Zhenja, ***
 *** Xandros, Melkij, Strelok etc pp.                                       ***
 ***                                                                        ***
 *** Thanks to:                                                             ***
 *** W.A. Mozart, Vivaldi, Beethoven, Poeta Magica, Kurtzweyl, Manowar,     ***
 *** Blind Guardian, Weltenbrand, In Extremo, Wolfsheim, Carl Orff, Zemfira ***
 *** ... most of my work was done with their music in the background ;)     ***
 ***                                                                        ***
 ******************************************************************************
 ******************************************************************************

 LEGAL STUFF:
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 Copyright (c) 1995-2003, -=Assarbad=- ["copyright holder(s)"]
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
 3. The name(s) of the copyright holder(s) may not be used to endorse or
    promote products derived from this software without specific prior written
    permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             .oooO     Oooo.
 ____________________________(   )_____(   )___________________________________
                              \ (       ) /
                               \_)     (_/

 ******************************************************************************)

program Portscan;
(*
  1.10d - Okay, upon request the whole file moves out of the EXE again to be
          able to customize the port descriptions ;)
  1.10c - now the programmer can optionally include the short names for the
          ports as string table resource using the PORTNAMES compiler switch.
          (A Perl script in the \SOURCE directory can be used to extract the
           names. Just put a file called "port-numbers.txt" into the directory
           and then execute the .CMD file to extract the names - get the file
           from: http://www.iana.org/assignments/port-numbers)
  1.10b - can be minimized to tray now by double clicking the caption
  1.10a - small enhancements
  1.10  - sports new scheduling scheme. Thanks to Hagen for pointing it out to me.
  1.00  - initial release

  The program can definitely be compiled with Delphi 3 through 5!

  The program will start and maybe run on Windows 9x. But when reaching a limit
  of 32K items in the listbox it will hang or whatever. I don't know. I just
  want you to notice it. It's a limitation of Windows 9x I am not willing to
  work around, since Windows 9x hopefully will disappear from PCs soon.
*)
uses
  Windows,
  Messages,
  ShellApi,
  CommCtrl,
  CommDlg,
  WinSock;

{$R MAIN.RES}
{$INCLUDE .\Include\FormatString.pas}
{$INCLUDE .\Include\GetFont.pas}

const
  IDD_DIALOG1 = 101;
  IDI_ICON1 = 102;
  IDI_ICON2 = 103;
  IDC_EDITIP = 1001;
  IDC_EDITPORT_FROM = 1005;
  IDC_EDITPORT_TO = 1008;
  IDC_LIST1 = 1009;
  IDC_BUTTON_OPENPORTS = 1010;
  IDC_BUTTON_SAVE = 1011;
  IDC_CHECK1 = 1012;
  IDC_EDIT_NUMTHREADS = 1014;
  IDC_SPIN_NUMTHREADS = 1015;
  IDC_STATIC_NUMTHREADS = 1016;
  IDC_STATIC_NUMITEMS = 1017;

// Some application defined window messages
  WM_ADDIP_TCPCONNPORT = WM_APP + 123; // open TCP port
  WM_ADDIP_TCPPORT = WM_APP + 124; // closed TCP port
  WM_ADDIP_UDPCONNPORT = WM_APP + 125; // open UDP port
  WM_ADDIP_UDPPORT = WM_APP + 126; // closed UDP port
  WM_SETCOUNTER = WM_APP + 200; // sets the thread counter STATIC
  WM_SHELLNOTIFY = WM_APP + 201;
  SC_TRAY = WM_APP + 202;

  maxports = $FFFF;
  cancelports = 1 + maxports * 2;
  allfiles_filterstring = 'Text files'#0'*.txt'#0'All files'#0'*.*'#0#0;
  portfile = 'ports.conf';

type
  PIP = ^TIP;
  TIP = record
    IP,
      StartPort,
      EndPort: DWORD;
    ThreadCounter: Integer;
  end;

  PPortArray = ^TPortArray;
  TPortArray = array[0..$FFFF] of string;

var
  portdesc: PPortArray;
  note: TNotifyIconData;
  numthreads: DWORD = $100; // FIXED!!!
  wsa: TWSAData;
  cs: TRTLCriticalSection;
  hDlg: HWND = 0;
  ct: Boolean = False; // Icon "counter"
  icons: array[0..1] of HICON; // Two alternating icons
  IP: TIP;
  gPortCounter: DWORD;
  MsgTaskbarcreated: DWORD = 0;

function EnumChildSetFonts(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
(*
  Iterates through all dialog child controls and sets fonts and text length limit.
*)
begin
  result := True;
// For any of the controls here, let's set the font :)
  case GetDlgCtrlID(hwnd) of
    IDC_LIST1,
      IDC_EDITIP,
      IDC_EDITPORT_FROM,
      IDC_EDITPORT_TO:
      SendMessage(hwnd, WM_SETFONT, lParam, ord(TRUE));
  end;
  case GetDlgCtrlID(hwnd) of
    IDC_LIST1,
      IDC_EDITIP:
      SendMessage(hwnd, EM_SETLIMITTEXT, 20, 0);
    IDC_EDITPORT_FROM,
      IDC_EDITPORT_TO:
      SendMessage(hwnd, EM_SETLIMITTEXT, 5, 0);
  end;
end;

function GetIP(hwnd: HWND): DWORD;
//  Get's an IP address in host byte order from the text of the IDC_EDITIP control
var
  IP: DWORD;
  pc: PChar;
begin
  result := 0;
  IP := GetWindowTextLength(GetDlgItem(hwnd, IDC_EDITIP)) + 2;
  GetMem(pc, IP);
  if Assigned(pc) then
  try
    ZeroMemory(pc, IP);
    GetWindowText(GetDlgItem(hwnd, IDC_EDITIP), pc, IP);
    result := ntohl(inet_addr(pc));
  finally
    FreeMem(pc);
  end;
end;

function ScanTCPPort(IP, Port: DWORD): Boolean;
//  Scans a specific TCP port and on a specific IP
var
  OPTON: DWORD;
  TCPsock: TSocket;
  A: TSockAddrIn;
begin
  result := False;
// Create/open a socket (stream, not datagram)
  TCPsock := socket(AF_INET, SOCK_STREAM, 0);
  if TCPsock <> INVALID_SOCKET then
  try
// Set socket options
    OPTON := 0;
    setsockopt(TCPsock, SOL_SOCKET, SO_KEEPALIVE, @OPTON, sizeof(OPTON));
    OPTON := 1;
    setsockopt(TCPsock, SOL_SOCKET, SO_DONTLINGER, @OPTON, sizeof(OPTON));
// Only for compatibility with WinSock 1.1! It's default on newer versions.
    setsockopt(TCPsock, IPPROTO_TCP, TCP_NODELAY, @OPTON, sizeof(OPTON));
// Reset and init address structure
    ZeroMemory(@A, sizeof(A));
    A.sin_family := AF_INET;
    A.sin_addr.S_addr := ntohl(IP);
    A.sin_port := htons(Port);
// Try to connect and return result
    result := connect(TCPsock, A, sizeof(A)) = 0;
  finally
// Close the socket
    closesocket(TCPsock);
  end;
end;

function BeepThread(unused: DWORD): DWORD; stdcall;
// Does a long beep
begin
  result := 0;
  Windows.Beep(200, 100);
  Windows.Beep(400, 100);
  Windows.Beep(600, 100);
  Windows.Beep(800, 100);
  Windows.Beep(1000, 100);
  Windows.Beep(1200, 100);
  Windows.Beep(1400, 100);
  Windows.Beep(1600, 100);
  Windows.Beep(1800, 100);
  Windows.Beep(2000, 100);
end;

function ScanThread(unused: DWORD): DWORD; stdcall;
// Does the job for ONE port each time. It loops in a loop that increases a global
// port counter. The next unscanned port is scanned by the next free thread
var
  lPort: DWORD;
begin
  result := 0;
// Thread counter
  InterLockedIncrement(IP.ThreadCounter);
// Post updated number of threads
  PostMessage(hDlg, WM_SETCOUNTER, IP.ThreadCounter, 0);
// Set lower thread priority
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_IDLE);
// Loop while the current port number is smaller or equal the end port number
  while True do
  begin
    asm
// Atomic operation
        MOV   EAX, 1
        XADD  gPortCounter, EAX
        MOV   lPort, EAX
    end;
// Exit condition
    if lPort > IP.EndPort then
      Break;
// Scan ports ...
    if ScanTCPPort(IP.IP, lPort) then
      PostMessage(hDlg, WM_ADDIP_TCPCONNPORT, IP.IP, lPort)
    else
      PostMessage(hDlg, WM_ADDIP_TCPPORT, IP.IP, lPort);
  end;
// Atomic operation ... decreases thread counter
  InterLockedDecrement(IP.ThreadCounter);
// Post updated number of threads
  PostMessage(hDlg, WM_SETCOUNTER, IP.ThreadCounter, 0);
end;

procedure TryPortscan(hwnd: HWND);
// Retrieves all necessary values from the dialog and starts scanning.
var
  i, TID: DWORD;
  trans: BOOL;
begin
  IP.IP := GetIP(hwnd);
  if (IP.IP <> INADDR_NONE) then
  begin
    SetDlgItemInt(hwnd, IDC_STATIC_NUMITEMS, 0, False);
    i := SendDlgItemMessage(hwnd, IDC_SPIN_NUMTHREADS, UDM_GETPOS, 0, 0);
    IP.StartPort := GetDlgItemInt(hwnd, IDC_EDITPORT_FROM, trans, False);
    IP.EndPort := GetDlgItemInt(hwnd, IDC_EDITPORT_TO, trans, False);
// If the ports have wrong order (max < min) then change them
    if IP.StartPort > IP.EndPort then
    begin
      TID := IP.StartPort;
      IP.StartPort := IP.EndPort;
      IP.EndPort := TID;
      if IP.EndPort > maxports then
        SetDlgItemInt(hwnd, IDC_EDITPORT_FROM, IP.StartPort, False);
      SetDlgItemInt(hwnd, IDC_EDITPORT_TO, IP.EndPort, False);
    end;
// Prevent thread switching
    if i > (IP.EndPort - IP.StartPort) then
      i := (IP.EndPort - IP.StartPort) + 1;
    SendDlgItemMessage(hwnd, IDC_LIST1, LB_RESETCONTENT, 0, 0);
    gPortCounter := IP.StartPort;
    IP.ThreadCounter := 0;
// Set lower thread priority
    SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_BELOW_NORMAL);
// Start a whole lott of threads ...
    for i := 0 to i - 1 do
// Parameter is the current counter value
      CreateThread(nil, $FFFF, @ScanThread, nil, 0, TID);
  end
  else
    MessageBox(hwnd, 'Please give a valid IP address and number of threads!', nil, 0);
end;

procedure EnableWindows(hwnd: HWND; b: BOOL);
// Enables or disables controls that might disturb while scanning
begin
  EnableWindow(GetDlgItem(hwnd, IDOK), b);
  EnableWindow(GetDlgItem(hwnd, IDC_EDIT_NUMTHREADS), b);
  EnableWindow(GetDlgItem(hwnd, IDC_EDITIP), b);
  EnableWindow(GetDlgItem(hwnd, IDC_EDITPORT_FROM), b);
  EnableWindow(GetDlgItem(hwnd, IDC_EDITPORT_TO), b);
  EnableWindow(GetDlgItem(hwnd, IDC_SPIN_NUMTHREADS), b);
//  EnableWindow(GetDlgItem(hwnd, IDC_BUTTON_SAVE), b);
end;

procedure SetIcon(hwnd: HWND; handle: HICON);
// Sets the main window's icon
begin
  SendMessage(hwnd, WM_SETICON, ICON_BIG, handle);
  SendMessage(hwnd, WM_SETICON, ICON_SMALL, handle);
end;

function GetFileName(hwnd: HWND; default: string; var returnname: string): Boolean;
// Gets the name for the file to save the report
var
  ofn: TOpenFilename;
  ofn_buffer: array[0..MAX_PATH] of Char;
begin
  ZeroMemory(@ofn_buffer, sizeof(ofn_buffer));
  ZeroMemory(@ofn, sizeof(ofn));
  lstrcpyn(@ofn_buffer[0], @default[1], sizeof(ofn_buffer));
  ofn.lStructSize := sizeof(ofn);
  ofn.lpstrFile := @ofn_buffer;
  ofn.hWndOwner := hwnd;
  ofn.hInstance := hInstance;
  ofn.lpstrFilter := @allfiles_filterstring[1];
  ofn.nMaxFile := sizeof(ofn_buffer);
  ofn.Flags := OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY;
  result := GetSaveFileName(ofn);
  if result then
    SetString(returnname, PChar(@ofn_buffer), lstrlen(@ofn_buffer[0]));
end;

function GetLBItem(hwnd: HWND; idx: Integer): string;
// Gets one listbox item in a string (by index)
var
  i: Integer;
  pc: PChar;
begin
  result := '';
  i := SendMessage(hwnd, LB_GETTEXTLEN, idx, 0) + 2;
  GetMem(pc, i);
  if Assigned(pc) then
  try
    ZeroMemory(pc, i);
    SendMessage(hwnd, LB_GETTEXT, idx, LPARAM(pc));
    SetString(result, pc, lstrlen(pc));
  finally
    FreeMem(pc);
  end;
end;

procedure CreateTrayIcon(hwnd: HWND);
// Creates the tray icon
begin
  note.cbSize := SizeOf(TNotifyIconData);
  note.wnd := hwnd;
  note.uID := SC_TRAY;
  note.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  note.uCallbackMessage := WM_SHELLNOTIFY;
  note.hIcon := icons[0];
  lstrcpy(note.szTip, 'FastScan (double click restores)');
  ShowWindow(hWnd, SW_HIDE);
  Shell_NotifyIcon(NIM_ADD, @note);
end;

procedure DestroyTrayIcon;
// Destroys the tray icon
begin
  Shell_NotifyIcon(NIM_DELETE, @note);
end;

procedure ModifyTrayIconText;
// Modifies the tray icon
begin
  Shell_NotifyIcon(NIM_MODIFY, @note);
end;

procedure BlinkTrayIcon;
// Actually blinks the tray icon
begin
  note.hIcon := icons[ord(ct)];
  ModifyTrayIconText;
end;

procedure TimerFunc(hwnd: HWND; uMsg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;
// Makes the tray icon blink when finished
begin
  ct := not ct;
  BlinkTrayIcon;
end;

function GetTCPPortDescription(IP: DWORD; Port: Word; ports: PPortArray): string;
begin
  result := Format('%3d.%3d.%3d.%3d:%5d [TCP] open', [
    Byte(IP shr 24),
      Byte(IP shr 16),
      Byte(IP shr 8),
      Byte(IP),
      Port]);
  if Assigned(ports) then
    if ports^[Port] <> '' then
      result := Format('%s -> %s', [result, ports^[Port]]);
end;

function DlgFunc(hwnd: HWND; umsg: UINT; wparam: WPARAM; lparam: LPARAM): BOOL; stdcall;
var
  s: string;
  hFile: THandle;
  written: DWORD;
  i: Integer;
  se: servent;
  pse: PServEnt absolute se;
begin
  Result := True;
  case umsg of
    WM_INITDIALOG:
      begin
        hDlg := hwnd;
        SetIcon(hwnd, icons[0]);
// Set fixed font for all edit fields
        EnumChildWindows(hwnd, @EnumChildSetFonts, GetFont(hwnd, 8, FW_NORMAL, True));
// Set initial IP address
        SetDlgItemText(hwnd, IDC_EDITIP, '127.0.0.1');
        SendDlgItemMessage(hwnd, IDC_SPIN_NUMTHREADS, UDM_SETRANGE, 0, MAKELONG(numthreads, 1));
        SendDlgItemMessage(hwnd, IDC_SPIN_NUMTHREADS, UDM_SETPOS, 0, MAKELONG(numthreads, 0));
// Set initial port range
        SetDlgItemInt(hwnd, IDC_EDITPORT_FROM, 0, False);
        SetDlgItemInt(hwnd, IDC_EDITPORT_TO, maxports, False);
        SetDlgItemInt(hwnd, IDC_STATIC_NUMTHREADS, 0, False);
        SetDlgItemInt(hwnd, IDC_STATIC_NUMITEMS, 0, False);
// Register the message
        MsgTaskbarcreated := RegisterWindowMessage('TaskbarCreated');
      end;
    WM_TIMER:
      case wParam of
        IDD_DIALOG1:
          begin
            ct := not ct;
            SetIcon(hwnd, icons[ord(ct)]);
          end;
      end;
    WM_SETCOUNTER:
      begin
        SetDlgItemInt(hwnd, IDC_STATIC_NUMTHREADS, wParam, False);
        if wParam > 0 then
          EnableWindows(hwnd, False)
        else
        begin
          EnableWindows(hwnd, True);
// Remove timer
          KillTimer(hwnd, IDD_DIALOG1);
// Reset icon
          SetIcon(hwnd, icons[0]);
// Set lower thread priority
          SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_NORMAL);
          if not IsWindowVisible(hwnd) then
          begin
// Make the tray icon blink
            SetTimer(hwnd, SC_TRAY, 350, @TimerFunc);
// Make a long beeeeep ;)
            CreateThread(nil, $FFFF, @BeepThread, nil, 0, PDWORD(nil)^);
          end;
        end;
      end;
    WM_ADDIP_TCPCONNPORT:
      begin
//        s := Format('%3.3d.%3.3d.%3.3d.%3.3d:%5.5d - ', [
        s := GetTCPPortDescription(wParam, lParam, portdesc);
        SendDlgItemMessage(hwnd, IDC_LIST1, LB_ADDSTRING, 0, Integer(@s[1]));
        if IsDlgButtonChecked(hwnd, IDC_CHECK1) = BST_CHECKED then
          SendDlgItemMessage(hwnd, IDC_LIST1, LB_SETTOPINDEX,
            SendDlgItemMessage(hwnd, IDC_LIST1, LB_GETCOUNT, 0, 0) - 1, 0);
        SetDlgItemInt(hwnd, IDC_STATIC_NUMITEMS, gPortCounter, False);
      end;
    WM_ADDIP_TCPPORT:
      SetDlgItemInt(hwnd, IDC_STATIC_NUMITEMS, gPortCounter, False);
    WM_CTLCOLOREDIT:
      case GetDlgCtrlID(lParam) of
        IDC_EDITIP:
          begin
            SetTextColor(wParam, RGB($00, $80, $00));
            SetBkColor(wParam, GetSysColor(COLOR_INFOBK));
            result := BOOL(GetSysColorBrush(COLOR_INFOBK));
          end;
        IDC_EDITPORT_FROM,
          IDC_EDITPORT_TO:
          begin
            SetTextColor(wParam, RGB($00, $00, $80));
            SetBkColor(wParam, GetSysColor(COLOR_INFOBK));
            result := BOOL(GetSysColorBrush(COLOR_INFOBK));
          end;
        IDC_EDIT_NUMTHREADS:
          begin
            SetTextColor(wParam, RGB($80, $00, $00));
            SetBkColor(wParam, GetSysColor(COLOR_INFOBK));
            result := BOOL(GetSysColorBrush(COLOR_INFOBK));
          end;
      else
        result := False;
      end;
    WM_CTLCOLORLISTBOX:
      case GetDlgCtrlID(lParam) of
        IDC_LIST1:
          begin
            SetTextColor(wParam, RGB($00, $00, $80));
            SetBkColor(wParam, GetSysColor(COLOR_BTNFACE));
            result := BOOL(GetSysColorBrush(COLOR_BTNFACE));
          end;
      else
        result := False;
      end;
    WM_CLOSE:
      EndDialog(hwnd, 0);
    WM_COMMAND:
      if HiWord(WParam) = BN_CLICKED then
        case LOWORD(wParam) of
          IDOK:
            begin
              SetTimer(hwnd, IDD_DIALOG1, 400, nil);
              TryPortScan(hwnd);
            end;
          IDCANCEL:
            SendMessage(hwnd, WM_CLOSE, 0, 0);
          IDC_BUTTON_OPENPORTS:
// Open the IANA website with port number assignments
            ShellExecute(hwnd,
              'open',
              'http://www.iana.org/assignments/port-numbers',
              nil,
              nil,
              SW_SHOW);
          IDC_BUTTON_SAVE:
            begin
              i := SendDlgItemMessage(hwnd, IDC_LIST1, LB_GETCOUNT, 0, 0);
              if i > 0 then
                if GetFileName(hwnd, 'ScanReport.txt', s) then
                begin
                  hFile := CreateFile(@s[1], GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
                  if ((hFile <> INVALID_HANDLE_VALUE) and (i <> LB_ERR)) then
                  try
                    for i := 0 to i do
                    begin
                      s := GetLBItem(GetDlgItem(hwnd, IDC_LIST1), i) + #13#10;
                      WriteFile(hFile, PChar(@s[1])^, length(s), written, nil);
                    end;
                  finally
                    CloseHandle(hFile);
                  end
                  else
                    MessageBox(hwnd, 'Could not create file.', nil, 0);
                end;
            end;
        end;
(******************************************************************************
 Handle: minimize to tray
 ******************************************************************************)
    WM_SIZE:
      if wParam = SIZE_MINIMIZED then
        CreateTrayIcon(hwnd);
    WM_SHELLNOTIFY:
      case wParam of
        SC_TRAY:
          case lParam of
            WM_LBUTTONDBLCLK:
              begin
                DestroyTrayIcon;
                ShowWindow(hWnd, SW_RESTORE);
                SetForeGroundWindow(hwnd);
              end;
          end;
      end;
    WM_NCLBUTTONDBLCLK:
      case wParam = HTCAPTION of
        TRUE: Showwindow(hwnd, SW_MINIMIZE);
      end;
  else
    if ((MsgTaskbarcreated <> 0) and (uMsg = MsgTaskbarcreated)) then
    begin
      DestroyTrayIcon;
      CreateTrayIcon(hwnd);
    end
    else
      Result := False;
  end;
end;

function InitPortArray(fname: string): PPortArray;
var
  f: Textfile;
  s: string;
  Port: Word;
  Code: Integer;
begin
  result := nil;
  AssignFile(f, fname);
{$I-}
  Reset(f);
{$I+}
  if IOResult = 0 then
  try
    GetMem(result, sizeof(result^));
    if Assigned(result) then
    begin
      ZeroMemory(result, sizeof(result^));
      while not EOF(f) do
      begin
        Readln(f, s);
        if s[1] = '#' then
          continue;
        val(copy(s, 1, 5), Port, Code);
        if Code = 0 then
          result^[Port] := copy(s, 7, length(s));
      end;
    end;
  finally
    CloseFile(f);
  end;
end;

begin
// Warning on Win9x
  if GetVersion and $80000000 <> 0 then
  begin
    MessageBox(0, 'Note: There are certain limitations on Windows 9x/Me which might' +
      ' cause the program to hang or not work at all! Be warned! You use it at your own risk.', 'Information', MB_ICONWARNING);
    numthreads := $F;
  end;
// Create critical section
  InitializeCriticalSection(cs);
// Init comctl library
  InitCommonControls;
  try
// Init WinSock (v 1.1)
    if WSAStartup(MAKEWORD(1, 1), wsa) = 0 then
    try
      icons[0] := LoadIcon(hInstance, MAKEINTRESOURCE(IDI_ICON1));
      icons[1] := LoadIcon(hInstance, MAKEINTRESOURCE(IDI_ICON2));
// Init port list
      portdesc := InitPortArray(portfile);
// Start main window
      DialogBoxParam(hInstance, MAKEINTRESOURCE(IDD_DIALOG1), 0, @dlgfunc, 0);
    finally
// Finit WinSock
      WSACleanup;
    end
    else
      MessageBox(0, 'Found no appropriate WinSock support. Version 1.1 needed.', nil, 0);
  finally
// Remove critical section
    DeleteCriticalSection(cs);
// Free the port list
    if Assigned(portdesc) then
      FreeMem(portdesc);
  end;
end.

