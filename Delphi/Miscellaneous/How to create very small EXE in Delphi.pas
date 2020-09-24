// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to create very small EXE in Delphi
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

program Project1;

uses
  Windows, Messages;
  {the Messages unit contains the windows
  Message constants like WM_COMMAND}

{$R *.RES}

var
   wClass: TWndClass;
   Msg: TMsg;

//------------------------------------------------------//
function WindowProc(hWnd,Msg,wParam,lParam:Integer):Integer; stdcall;
begin
     if Msg = WM_DESTROY then PostQuitMessage(0);
     Result := DefWindowProc(hWnd,Msg,wParam,lParam);
end;
//------------------------------------------------------//
begin
     wClass.lpszClassName:= 'CN';
     wClass.lpfnWndProc :=  @WindowProc;

     {CreateWindow( ) will not work without setting the
     2 wClass parameters above}

     wClass.hInstance := hInstance;
     wClass.hbrBackground:= 1;

     {CreateWindow( ) will still create a window without the
     2 wClass parameters above, but they shoud be included}

     // wClass.hIcon := LoadIcon(hInstance,'MAINICON');
     // wClass.hCursor := LoadCursor(0,IDC_ARROW);

     RegisterClass(wClass);

     CreateWindow(wClass.lpszClassName,'Title', WS_OVERLAPPEDWINDOW or WS_VISIBLE, -1, -1, 100, 100, 0, 0, hInstance, nil);

     while GetMessage(Msg,0,0,0) do
           DispatchMessage(Msg);
end. //program end
