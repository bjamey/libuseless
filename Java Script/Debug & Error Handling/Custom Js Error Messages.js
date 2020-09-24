// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Custom Js Error Messages
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Custom Js Error Messages

function handleErrors(msg, url, line)
{
    var errorString = "JavaScript Error Occured\n";
    errorString += "Message: "+msg+"\n";
    errorString += "Url: "+url+"\n";
    errorString += "Line: "+line;

    alert(errorString);

    return true;
}

window.onerror = handleErrors;
