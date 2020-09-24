// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Ensure your page is not opened in a frame
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

if (top.location != self.location)
{
    top.location.href = self.location.href;
}
