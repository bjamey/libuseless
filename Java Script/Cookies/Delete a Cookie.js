// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Delete a Cookie
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Delete a Cookie

function DeleteCookie(strName)
{
     document.cookie = strName + "=" + "; expires = Thu, 01-Jan-70 00:00:01 GMT";
}
