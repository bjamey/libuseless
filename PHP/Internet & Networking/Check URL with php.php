<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Check URL with php

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

 // Note: allow_url_fopen must be turned on

 function http_test_existance($url) {
     return (($fp = @fopen($url, 'r')) === false) ? false : @fclose($fp);
 }

?>
