// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: GetRes (Get Screen Resolution)
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------
//
// Out  : int: screen width
//
// ----------------------------------------------------------------------------
int __fastcall GetRes(void)  
{
  HWND attualewnd = GetDesktopWindow();
  HDC attuale = GetDC(attualewnd);
  unsigned int TestX = GetDeviceCaps(attuale, HORZRES);
  return(TestX);
}

                                    
