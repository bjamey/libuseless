<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Check whether string begins with given string

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

 // Checks whether $string begins with $search
 function string_begins_with($string, $search)
 {
     return (strncmp($string, $search, strlen($search)) == 0);
 }

?>
