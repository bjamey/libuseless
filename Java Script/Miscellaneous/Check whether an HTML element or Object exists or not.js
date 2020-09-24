// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check whether an HTML element or Object exists or not
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  Check whether an HTML element/Object exists or not.

  This small javascript function will help you to check if an HTML
  object.Element exists in a page from the page itself or from a
  popup window.

  --------
  Note :
  --------
  if the inParent is true then the object/elt is checked for its
  existence in the parent/opener’s document.

  i.e., it will be useful to check from a popup window.
  To check in the current document itself , then set inParent
  value as false.
-->

function chkObject(inParent, theVal)
{
  if(inParent)
  {
          if (window.opener.document.getElementById(theVal) != null) {
             return true;
          } else {
             return false;
          }
  } else {
          if (document.getElementById(theVal) != null)
          {
             return true;
          } else {
             return false;
          }
  }
}
