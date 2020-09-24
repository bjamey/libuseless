<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Convert a Hex color into RGB

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: hex2rgb (PHP)
** Desc: With this function you can convert a normal HEX-color (like #FF00FF) into it's RGB values (Array(179,218,245)).
** Example: see below
** Author: Jonas John
*/

function hex2rgb($color){
    $color = str_replace('#', '', $color);
    if (strlen($color) != 6){ return array(0,0,0); }
    $rgb = array();
    for ($x=0; $x<3; $x++)
    {
        $rgb[$x] = hexdec(substr($color, (2 * $x), 2));
    }
    return $rgb;
}


// Example usage:
print_r(hex2rgb('#B3DAF5'));

/*
Returns an array (R,G,B):

Array
(
    [0] => 179
    [1] => 218
    [2] => 245
)
*/

// Another cool way to define RGB colors with
// Hex values: (like #B3DAF5)

$rgb = array(0xB3, 0xDA, 0xF5);

print_r($rgb);

/* output:

Array
(
    [0] => 179
    [1] => 218
    [2] => 245
)

*/

?>
