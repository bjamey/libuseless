<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Email address validator

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
Original script by Tobias Ratschiller.

* top level domain must have at least 2 chars
* there can be more than one dot in the address
*/

    function is_email($address) {
      $rc1 = (ereg('^[-!#$%&'*+./0-9=?A-Z^_`a-z{|}~]+'.
             '@'.
             '[-!#$%&'*+\/0-9=?A-Z^_`a-z{|}~]+.'.
             '[-!#$%&'*+\./0-9=?A-Z^_`a-z{|}~]+$',
             $address));
      $rc2 = (preg_match('/.+.ww+$/',$address));
      return ($rc1 && $rc2);
    }

?>
