// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Detecting Ajax Support
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/*
  check if your browser/javascript supports Ajax.
  For this we can use prototype’s getTransport method.
*/

function AjaxIsSupported ()
{
    return (Ajax.getTransport());
}

/*
  You can include this onload of your page. Make sure that
  before checking this , to include the prototype.js in your page

  This will actually check for XML parsers in IE / FF with
  browser specific methods.
*/
