// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Tray Icon management
//
// How to reduce application to Tray Bar (and back)
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

uses
  ShellApi;                // don't forget to add ShellApi To Uses
 
const
  WM_CAllBack = WM_USER;   // my call back constant
                           // I could of just used wm_user

type
  TForm1 = class(TForm)
    // my call back procedure
    procedure WM_CALLBACKPRO(var msg : TMessage); message wm_callBack; 
    // Minimize procedure
    procedure MinimizeToTray;                                          

var
  Form1: TForm1;                         // The form ;)
  hIco : HICON;                          // Icon handle
  TrayIcon : TNotifyIconData;            // Notify Icon Data structure

implementation


procedure TForm1.WM_CALLBACKPRO(var msg : TMessage);
begin
  case msg.LParam of
    // is from the lparam so if right mouse button is pressed
    WM_RBUTTONDOWN : 
      begin
      end;
    // is from the lparam so if left mouse button is pressed
    WM_LBUTTONDOWN :
      begin
        Shell_NotifyIcon(NIM_DELETE,@TrayIcon); // Delete The Tray Icon 
        Form1.Visible := True;                  // Show The Form Again
      end;
  end;
end;


procedure TForm1.MinimizeToTray;
begin
  Form1.Visible := False;                          // hide the form  
  // give the application icon handle to hIco
  hIco := application.Icon.Handle;             
  // Get The Size Of Byte Of TNotifyIconData
  Trayicon.cbSize := SizeOf(TNotifyIconData);  
  // Say The Icon Is Coming From The Form
  Trayicon.Wnd := handle;                      
  // Give A Tip Message With Mouse Over
  Trayicon.szTip := 'Right click for options'; 
  // Give It A Identifier of your icon
  Trayicon.uID := 1;                           
  // give the hicon to the tray icon
  TrayIcon.hIcon := hIco;                     
  // my callback function so when click it does something
  TrayIcon.uCallbackMessage := WM_CAllBack;    
  // TrayIcon flags to say what it can do
  Trayicon.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP; 
  // Add The Icon To The Tray
  Shell_NotifyIcon(NIM_ADD,@trayicon);         
end;
