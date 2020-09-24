// ----------------------------------------------------------------------------
//                                      DTT 2.2.0.5  (c)2009 FSL - FreeSoftLand
// Title: Check whether a mouse button is being pressed
//
// Date : 13/04/2009
// By   : FSL
// ----------------------------------------------------------------------------

...
     
uses
  Windows;   
  
...
                      
//ABtn can be either VK_LBUTTON, VK_MBUTTON, or VK_RBUTTON
function IsBtnPressed(ABtn: integer): boolean;
begin         
  result := (GetAsyncKeyState(ABtn) and $8000) = $8000;        
end;              
