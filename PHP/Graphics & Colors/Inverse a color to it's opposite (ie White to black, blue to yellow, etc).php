<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Inverse a color to it's opposite· (ie· White to black, blue to yellow,
          etc·)

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: color_inverse (PHP)
** Desc: This function inverses a color to it's opposite.(White to black, blue to yellow, etc.)
** Example: see below
** Author: Jonas John
*/

function color_inverse($color){
    $color = str_replace('#', '', $color);
    if (strlen($color) != 6){ return '000000'; }
    $rgb = '';
    for ($x=0;$x<3;$x++){
        $c = 255 - hexdec(substr($color,(2*$x),2));
        $c = ($c < 0) ? 0 : dechex($c);
        $rgb .= (strlen($c) < 2) ? '0'.$c : $c;
    }
    return '#'.$rgb;
}

/*
** Examples:
*/

// black -> white
print color_inverse('#000000');
// --> returns #ffffff

// blue -> yellow
print color_inverse('#0000FF');
// --> #FFFF00

?>
