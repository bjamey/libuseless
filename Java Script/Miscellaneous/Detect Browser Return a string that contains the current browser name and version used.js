// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Detect Browser Return a string that contains the current browser name and version used
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- ----------------------------------------------------------------
DetectBrowser: Return a string that contains the current
                browser name and version used.

 Parameters:

 Returns: String
---------------------------------------------------------------- -->
function DetectBrowser()
{
        var temp = navigator.appName;
        temp = temp.toLowerCase();

        if (temp == 'microsoft internet explorer')
                return 'IE' + navigator.appVersion
        else
                return 'NS' + navigator.appVersion;
}
