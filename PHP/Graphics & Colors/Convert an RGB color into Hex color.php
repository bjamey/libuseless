<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Convert an RGB color into Hex color

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: rgb2hex (PHP)
** Desc: If you need to convert RGB-color into HEX-color, use this.
** Example: rgb2hex(65280); -> returns 00FF00
** Author: Jonas John
*/

function rgb2hex($rgb){
   return sprintf("%06X", $rgb);
}

/*
** Examples:
*/

print rgb2hex(0x00FF00);
// returns --> 00FF00

print rgb2hex(65280);
// returns --> 00FF00

?>
