// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Flexible Javascript Events
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function addEvent( obj, type, fn )
{
        if (obj.addEventListener)
                obj.addEventListener( type, fn, false );
        else if (obj.attachEvent)
        {
                obj["e"+type+fn] = fn;
                obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
                obj.attachEvent( "on"+type, obj[type+fn] );
        }
}

// ----------------------------------------------------- //
function removeEvent( obj, type, fn )
{
        if (obj.removeEventListener)
                obj.removeEventListener( type, fn, false );
        else if (obj.detachEvent)
        {
                obj.detachEvent( "on"+type, obj[type+fn] );
                obj[type+fn] = null;
                obj["e"+type+fn] = null;
        }
}
