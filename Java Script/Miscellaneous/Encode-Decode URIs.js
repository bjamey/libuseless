// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Encode-Decode URIs
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
   If you plan on doing anything outside of North America, then
   you'd better encode the things you pass back and forth
   the escape() method in Javascript is deprecated -- should use
   encodeURIComponent if available
-->

function encode( uri )
{
    if (encodeURIComponent) {
        return encodeURIComponent(uri);
    }

    if (escape) {
        return escape(uri);
    }
}

// -------------------------------------- //
function decode( uri ) {
    uri = uri.replace(/\+/g, ' ');

    if (decodeURIComponent) {
        return decodeURIComponent(uri);
    }

    if (unescape) {
        return unescape(uri);
    }

    return uri;
}
