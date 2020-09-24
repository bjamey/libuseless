// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Debugging in javascript without alert dialog
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* Debugging in javascript without alert dialog */

var dwin = null;
function debug(msg)
{
    if ((dwin == null) || (dwin.closed))
    {
        dwin = window.open("","debugconsole","scrollbars=yes,resizable=yes,height=100,width=300");
        dwin.document.open("text/html", "replace");
    }

    dwin.document.writeln('<br/>'+msg);
    dwin.scrollTo(0,10000);
    dwin.focus();

    // uncomment this if you want to see only last message , not
    // all the previous messages

    // dwin.document.close();
}
