<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Checks if a IP adress has a valid format

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: ipadress_is_valid (PHP)
** Desc: Checks if a IP adress has a valid format
** Example: see below
** Author: Jonas John
*/

function ipadress_is_valid($ip){

    if (preg_match('/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/', $ip)){
        return true;
    }

    return false;

}

// examples:

var_dump(ipadress_is_valid('266.178.125.1'));
// => bool(true)

var_dump(ipadress_is_valid('266...1'));
// => bool(false)

var_dump(ipadress_is_valid('127001'));
// => bool(false)

var_dump(ipadress_is_valid('127.0.0.1'));
// => bool(true)

?>
