// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Show-hide titlebar of a form
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

...
uses
  Forms, Windows;
...
procedure ShowTitlebar(AForm: TForm; AShow: boolean);
var
  style: longint;
begin
  with AForm do
  begin
    if BorderStyle = bsNone then
      exit;
    style := GetWindowLong(Handle, GWL_STYLE);
    if AShow then
    begin
      if (style and WS_CAPTION) = WS_CAPTION then
        exit;
      case BorderStyle of
        bsSingle, bsSizeable:
          SetWindowLong(Handle, GWL_STYLE, style or WS_CAPTION or WS_BORDER);
        bsDialog:
          SetWindowLong(Handle, GWL_STYLE, style or WS_CAPTION or DS_MODALFRAME or WS_DLGFRAME);
      end;
    end
    else
    begin
      if (style and WS_CAPTION) = 0 then
        exit;
      case BorderStyle of
        bsSingle, bsSizeable:
          SetWindowLong(Handle, GWL_STYLE, style and (not(WS_CAPTION)) or WS_BORDER);
        bsDialog:
          SetWindowLong(Handle, GWL_STYLE, style and (not(WS_CAPTION)) or DS_MODALFRAME or WS_DLGFRAME);
      end;                                                                          
    end;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or
      SWP_FRAMECHANGED or SWP_NOSENDCHANGING); 
  end;
end;
