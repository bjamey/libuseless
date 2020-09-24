// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Is Webbrowser text selected
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// If you need to know if there is any text
// selected in a TWebbrowser use this code:

// Required unit: MSHTML

function HasSelection(Document: IHTMLDocument2): Boolean;
var
   LEnabled: Boolean;
   pSel:     IHTMLSelectionObject;
   pRange:   IHTMLTxtRange;
begin
     LEnabled := False;
     if Document <> nil then
     begin
          pSel := Document.selection as IHTMLSelectionObject;

          if pSel <> nil then
          begin
               if pSel.type_ = 'Text' then
               begin
                    pRange := pSel.createRange as IHTMLTxtRange;
                    if (pRange <> nil) and (Length(Trim(pRange.text)) > 0) then
                        LEnabled := True;
               end;
          end;
     end;

     Result := LEnabled;
end;


// --------
// Usage:
// --------
if HasSelection(WebBrowser1.Document as IHTMLDocument2) then
begin
     // ...
end;
