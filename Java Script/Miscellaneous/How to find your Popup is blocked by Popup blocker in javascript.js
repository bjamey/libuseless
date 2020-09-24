// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to find your Popup is blocked by Popup blocker in javascript
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  How to find your Popup is blocked by Popup blocker in javascript
  when using window.open.

  We open a window using window.open() in our pages using javascript.
  But if there is popup blocker sitting in the client machine and
  the user is not aware the popup blocker is blocking the popup
  window from your site, we can inform him the popup is blocked
  and ask him to remove that. How?
-->

winHandle = window.open('yourfile.htm' +
            "?newwin=true", "_top", "width=" + wwidth +
            ",height=" + wheight +
            ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

if (winHandle == null)
{
    alert("Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
}               
