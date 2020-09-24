// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Toggle object visibility
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function toggle(obj)
{
        var el = document.getElementById(obj);

        if ( el.style.display != 'none' ) {
                el.style.display = 'none';
        }
        else {
                el.style.display = '';
        }
}
