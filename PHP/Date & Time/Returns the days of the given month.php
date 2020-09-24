<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Returns the days of the given month

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: get_days_for_month (PHP)
** Desc: This function returns the days of the given month. It may useful for calendar generation or something similar...
** Example:
** Author: Jonas John
*/

function get_days_for_month($m)
{
    $m = intval($m);
    if ($m == 4 || $m == 6 || $m == 9 || $m == 11) {
        return 30;
    }
    elseif ($m == 02) { return 28; }
    return 31;
}

?>
