<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Trim a whole array recursively

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: trim_array (PHP)
** Desc: trims a whole array recursively
** Example: trim_array(array(' a ', ' b ', ' c ')); => returns array('a','b','c');
** Author: Jonas
*/

function trim_array($arr)
{
    if (!is_array($arr)){ return $arr; }

    while (list($key, $value) = each($arr))
    {
        if (is_array($value))
        {
            $arr[$key] = trim_array($value);
        }
        else {
            $arr[$key] = trim($value);
        }
    }

    return $arr;
}

?>
