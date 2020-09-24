<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Time to load a webpage

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

   /*
   ** Function: time to load (PHP)
   ** Desc: On this way you can find out how long a page needs to load.
   ** Example: see below
   ** Author: Jonas John
   */

   $start = time();

   // put a long operation in here
   sleep(2);


   $diff = time() - $start;

   print "This page needed $diff seconds to load :-)";

   // if you want a more exact value, you could use the
   // microtime function

?>
