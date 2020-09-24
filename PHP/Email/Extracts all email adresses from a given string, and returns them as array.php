<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Extracts all email adresses from a given string, and returns them as array

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: extract_emails (PHP)
** Desc: This function extracts all E-Mail adresses from a given string, and returns them as array.
** Author: Jonas John
*/

function extract_emails($str)
{
    // This regular expression extracts all emails from
    // a string:
    $regexp = '/([a-z0-9_\.\-])+\@(([a-z0-9\-])+\.)+([a-z0-9]{2,4})+/i';
    preg_match_all($regexp, $str, $m);

    return isset($m[0]) ? $m[0] : array();
}
?>
